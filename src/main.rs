use iced::widget::{button, column, text};
use iced::Element;

#[derive(Default)]
struct Model {
    value: i32,
}

#[derive(Debug, Clone)]
enum Message {
    Increment,
    Decrement,
}

pub fn main() -> iced::Result {
    iced::run("A cool counter", update, view)
}

fn update(counter: &mut Model, message: Message) {
    match message {
        Message::Increment => counter.value += 1,
        Message::Decrement => counter.value -= 1,
    }
}

fn view(counter: &Model) -> Element<Message> {
    column![
        button("-").on_press(Message::Decrement),
        text(counter.value),
        button("+").on_press(Message::Increment),
    ]
    .spacing(10)
    .into()
}
