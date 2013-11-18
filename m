Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:44954 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3KRQPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 11:15:30 -0500
Received: by mail-la0-f44.google.com with SMTP id ep20so5164810lab.31
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 08:15:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEk6gTB2as8XccgY3E9MBTXRCmKwLk9+9KzNx5YFqEz0L3A3tw@mail.gmail.com>
References: <CAEk6gTB2as8XccgY3E9MBTXRCmKwLk9+9KzNx5YFqEz0L3A3tw@mail.gmail.com>
Date: Mon, 18 Nov 2013 17:15:29 +0100
Message-ID: <CAEk6gTDkn19tK9wz1k8apnw6LZpsE1wPVqQOGq+uvkqY7LfdjA@mail.gmail.com> (sfid-20131118_171535_132663_F5EAF8F1)
Subject: Re: AP mode with hostapd
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all, debugging a bit more, with debug log enabled gives log I pasted below.

Any idea what's happening?

BR,
Drasko


ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbec21b40, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf252f3e, length: 7
ath6kl: htc_try_send: (queue:0xbf3e7cd8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184ce4 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf3e7c98, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec21b40
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: Removing 01:00:5e:00:00:01 from multicast filter
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf124f80
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec21c00
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec21cc0
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec21d80
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec21e40
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec21f00
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c000
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c0c0
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c180
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c240
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c300
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c3c0
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c480
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c540
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c600
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c6c0
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbec2c780
ath6kl: wmi tx id 61466 len 6 flag 0
wmi tx 00000000: 01 00 5e 00 00 01                                ..^...
ath6kl: ath6kl_control_tx: skb=0xbec2c840, len=0xc eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28af7e, length: 12
ath6kl: htc_try_send: (queue:0xbf3e7cc8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e14 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbec2c900, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28b1be, length: 7
ath6kl: htc_try_send: (queue:0xbf3e7cf8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e14 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_cfg80211_set_power_mgmt: pmgmt 0, timeout -1
ath6kl: ath6kl_cfg80211_set_power_mgmt: max perf
ath6kl: wmi tx id 18 len 1 flag 0
wmi tx 00000000: 02                                               .
ath6kl: ath6kl_control_tx: skb=0xbec2c9c0, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28b3fe, length: 7
ath6kl: htc_try_send: (queue:0xbf3e7ca8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e14 , queue depth: 3
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbec2ca80, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28b63e, length: 7
ath6kl: htc_try_send: (queue:0xbf3e7b88 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e14 , queue depth: 4
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: Adding 01:00:5e:00:00:01 to multicast filter list
ath6kl: wmi tx id 61465 len 6 flag 0
wmi tx 00000000: 01 00 5e 00 00 01                                ..^...
ath6kl: ath6kl_control_tx: skb=0xbec2cb40, len=0xc eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28b87e, length: 12
ath6kl: htc_try_send: (queue:0xbf3e7b78 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e14 , queue depth: 5
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl usb xmit callback buf:0xbec21b40
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec21b40 data=0xbf252f3e len=0x7 eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf328180
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e14 , queue depth: 5
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 4
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec2c840
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 18 bytes
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 4
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:18
ath6kl: ath6kl usb xmit callback buf:0xbec2c840
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340580
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec2c840 data=0xbf28af7e len=0xc eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf3746c0
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 4
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d7c , queue depth: 3
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec2c900
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d7c , queue depth: 3
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340800
ath6kl: ath6kl usb recv callback buf:0xbf374600
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d7c , queue depth: 3
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d30 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec2c9c0
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d30 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340180
ath6kl: ath6kl usb recv callback buf:0xbf374540
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d30 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec2ca80
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340c00
ath6kl: ath6kl usb recv callback buf:0xbf374480
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec2cb40
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 18 bytes
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:18
ath6kl: ath6kl usb xmit callback buf:0xbec2c900
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340e80
ath6kl: ath6kl_tx_complete: skb=0xbec2c900 data=0xbf28b1be len=0x7 eid=1 OK
ath6kl: ath6kl usb xmit callback buf:0xbec2c9c0
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec2c9c0 data=0xbf28b3fe len=0x7 eid=1 OK
ath6kl: ath6kl usb xmit callback buf:0xbec2ca80
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec2ca80 data=0xbf28b63e len=0x7 eid=1 OK
ath6kl: ath6kl usb xmit callback buf:0xbec2cb40
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec2cb40 data=0xbf28b87e len=0xc eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf374900
ath6kl: Report indicated 1 credits to distribute
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbec1f3c0, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28babe, length: 7
ath6kl: htc_try_send: (queue:0xbf261cf8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf261cb8, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec1f3c0
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340e00
ath6kl: ath6kl usb xmit callback buf:0xbec1f3c0
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec1f3c0 data=0xbf28babe len=0x7 eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf3749c0
ath6kl: Report indicated 1 credits to distribute
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbec1f840, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28bcfe, length: 7
ath6kl: htc_try_send: (queue:0xbf261cf8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf261cb8, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec1f840
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340d80
ath6kl: ath6kl usb xmit callback buf:0xbec1f840
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec1f840 data=0xbf28bcfe len=0x7 eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf374a80
ath6kl: Report indicated 1 credits to distribute
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbf338f00, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf28c87e, length: 7
ath6kl: htc_try_send: (queue:0xbf3e1cf8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf3e1cb8, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbf338f00
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340000
ath6kl: ath6kl usb xmit callback buf:0xbf338f00
ath6kl: wmi tx id 8 len 20 flag 0
wmi tx 00000000: ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbf338f00 data=0xbf28c87e len=0x7 eid=1 OK
wmi tx 00000010: 00 00 00 00                                      ....
ath6kl: ath6kl usb recv callback buf:0xbf374b40
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_control_tx: skb=0xbec4dc00, len=0x1a eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19bb7e, length: 26
ath6kl: htc_try_send: (queue:0xbf3e1cc8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf3e1c88, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4dc00
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 32 bytes
ath6kl: ath6kl_cfg80211_scan_complete_event: status aborted
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:32
ath6kl: ath6kl usb xmit callback buf:0xbec4dc00
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340f80
ath6kl: ath6kl_tx_complete: skb=0xbec4dc00 data=0xbf19bb7e len=0x1a eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf374c00
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_cfg80211_change_iface: type 3
ath6kl: ath6kl_mgmt_frame_register: frame_type=0xd0 reg=1
ath6kl: ath6kl_mgmt_frame_register: frame_type=0x40 reg=1
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbec4d6c0, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19bdbe, length: 7
ath6kl: htc_try_send: (queue:0xbf3e1cd8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf3e1c98, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4d6c0
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: Removing 01:00:5e:00:00:01 from multicast filter
ath6kl: wmi tx id 61466 len 6 flag 0
wmi tx 00000000: 01 00 5e 00 00 01                                ..^...
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: ath6kl_control_tx: skb=0xbec4dd80, len=0xc eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19bffe, length: 12
ath6kl: htc_try_send: (queue:0xbf3e1cc8 depth:1)
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340900
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d30 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl usb xmit callback buf:0xbec4d6c0
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: ath6kl_control_tx: skb=0xbec4d600, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19c23e, length: 7
ath6kl: htc_try_send: (queue:0xbf3e1cf8 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d30 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec4d6c0 data=0xbf19bdbe len=0x7 eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf374cc0
ath6kl: disabling multicast-all filter
ath6kl: wmi tx id 61481 len 1 flag 0
wmi tx 00000000: 00                                               .
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: ath6kl_control_tx: skb=0xbec4d480, len=0x7 eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19c47e, length: 7
ath6kl: htc_try_send: (queue:0xbf3e1b88 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d30 , queue depth: 3
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d7c , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: htc_issue_packets: queue: 0xbf3e1b48, pkts 1
ath6kl: Report indicated 1 credits to distribute
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4dd80
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 18 bytes
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d7c , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: Adding 01:00:5e:00:00:01 to multicast filter list
ath6kl: wmi tx id 61465 len 6 flag 0
wmi tx 00000000: 01 00 5e 00 00 01                                ..^...
ath6kl: ath6kl_control_tx: skb=0xbec4d3c0, len=0xc eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19c6be, length: 12
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:18
ath6kl: htc_try_send: (queue:0xbf3e1b78 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d7c , queue depth: 3
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340680
ath6kl: ath6kl usb xmit callback buf:0xbec4dd80
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec4dd80 data=0xbf19bffe len=0xc eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf374d80
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184d7c , queue depth: 3
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4d600
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340600
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl usb recv callback buf:0xbf374e40
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 2
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4d480
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 13 bytes
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340880
ath6kl: ath6kl usb recv callback buf:0xbf374f00
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4d3c0
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 18 bytes
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl usb xmit callback buf:0xbec4d600
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:18
ath6kl: ath6kl_tx_complete: skb=0xbec4d600 data=0xbf19c23e len=0x7 eid=1 OK
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340380
ath6kl: ath6kl usb xmit callback buf:0xbec4d480
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec4d480 data=0xbf19c47e len=0x7 eid=1 OK
ath6kl: ath6kl usb xmit callback buf:0xbec4d3c0
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec4d3c0 data=0xbf19c6be len=0xc eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf33bb40
ath6kl: Report indicated 1 credits to distribute
ath6kl: ap_set_mlme: cmd=3 reason=2
ath6kl: wmi tx id 61456 len 9 flag 0
wmi tx 00000000: ff ff ff ff ff ff 02 00 03                       .........
ath6kl: ath6kl_control_tx: skb=0xbec4d780, len=0xf eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19c8fe, length: 15
ath6kl: htc_try_send: (queue:0xbf3e1b38 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf3e1af8, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4d780
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 21 bytes
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:21
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340300
ath6kl: ap_set_mlme: cmd=3 reason=2
ath6kl: wmi tx id 61456 len 9 flag 0
wmi tx 00000000: ff ff ff ff ff ff 02 00 03                       .........
ath6kl: ath6kl_control_tx: skb=0xbec4d900, len=0xf eid =1
ath6kl: ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf19cb3e, length: 15
ath6kl: htc_try_send: (queue:0xbf3e1b38 depth:1)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:0
ath6kl: ath6kl_cfg80211_del_key: index 0
ath6kl: ath6kl_cfg80211_del_key: index 0 is empty
ath6kl: ath6kl_cfg80211_del_key: index 1
ath6kl: ath6kl_cfg80211_del_key: index 1 is empty
ath6kl: ath6kl_cfg80211_del_key: index 2
ath6kl: ath6kl_cfg80211_del_key: index 2 is empty
ath6kl: ath6kl_cfg80211_del_key: index 3
ath6kl: ath6kl_cfg80211_del_key: index 3 is empty
ath6kl: ath6kl usb xmit callback buf:0xbec4d780
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec4d780 data=0xbf19c8fe len=0xf eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf33ba80
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184e60 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4d900
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 21 bytes
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:21
ath6kl: ath6kl usb xmit callback buf:0xbec4d900
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf340a80
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ed480
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ed300
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ed3c0
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ed600
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ed6c0
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1edd80
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1edf00
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1eda80
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1edb40
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ede40
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ed000
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ed900
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ef6c0
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ef600
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ef540
ath6kl: ath6kl usb: bulk recv submit:5, 0xC0410280 (ep:0x82), 1700
bytes buf:0xbf1ef9c0
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec4d900 data=0xbf19cb3e len=0xf eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbf33b9c0
ath6kl: Report indicated 1 credits to distribute
rx 000002a0: 00 00 14 00 00 00 13 19 2f 84 ff ff 00 00 00 00  ......../.......
rx 000002b0: 00 00 13 19 2f 84 00 00 00 00 00 00 00 00 13 19  ..../...........
rx 000002c0: 2f 84 00 00 00 00 00 00 00 00 13 19 2e 04 13 19  /...............
rx 000002d0: 10 ac 06 00 00 00 00 00 00 00 14 19 10 ac 06 00  ................
rx 000002e0: 00 00 00 00 00 00 d7 4f 29 84 29 f0 00 00 01 00  .......O).).....
rx 000002f0: 00 00 d7 4f 2d 84 29 f0 00 00 01 00 00 00 d7 4f  ...O-.)........O
rx 00000300: 2f 84 00 00 00 00 00 00 00 00 d7 4f 2e 04 d8 4f  /..........O...O
rx 00000310: 29 84 1a f0 00 00 06 00 00 00 d8 4f 2d 84 1a f0  )..........O-...
rx 00000320: 00 00 06 00 00 00 d8 4f 2f 84 01 00 5e 00 00 01  .......O/...^...
rx 00000330: 00 00 d8 4f 2e 04 d8 4f 29 84 29 f0 00 00 01 00  ...O...O).).....
rx 00000340: 00 00 d8 4f 2d 84 29 f0 00 00 01 00 00 00 d8 4f  ...O-.)........O
rx 00000350: 2f 84 00 00 00 00 00 00 00 00 d8 4f 2e 04 d8 4f  /..........O...O
rx 00000360: 29 84 12 00 00 00 01 00 00 00 d8 4f 2d 84 12 00  )..........O-...
rx 00000370: 00 00 01 00 00 00 d8 4f 2f 84 02 00 00 00 00 00  .......O/.......
rx 00000380: 00 00 d8 4f 2e 04 d9 4f 29 84 29 f0 00 00 01 00  ...O...O).).....
rx 00000390: 00 00 d9 4f 2d 84 29 f0 00 00 01 00 00 00 d9 4f  ...O-.)........O
rx 000003a0: 2f 84 00 00 00 00 00 00 00 00 d9 4f 2e 04 d9 4f  /..........O...O
rx 000003b0: 29 84 19 f0 00 00 06 00 00 00 d9 4f 2d 84 19 f0  )..........O-...
rx 000003c0: 00 00 06 00 00 00 d9 4f 2f 84 01 00 5e 00 00 01  .......O/...^...
rx 000003d0: 00 00 d9 4f 2e 04 e0 4f 29 84 29 f0 00 00 01 00  ...O...O).).....
rx 000003e0: 00 00 e0 4f 2d 84 29 f0 00 00 01 00 00 00 e0 4f  ...O-.)........O
rx 000003f0: 2f 84 00 00 00 00 00 00 00 00 e0 4f 2e 04 e1 4f  /..........O...O
rx 00000400: 29 84 29 f0 00 00 01 00 00 00 e1 4f 2d 84 29 f0  ).)........O-.).
rx 00000410: 00 00 01 00 00 00 e1 4f 2f 84 00 00 00 00 00 00  .......O/.......
rx 00000420: 00 00 e1 4f 2e 04 90 50 29 84 29 f0 00 00 01 00  ...O...P).).....
rx 00000430: 00 00 90 50 2d 84 29 f0 00 00 01 00 00 00 90 50  ...P-.)........P
rx 00000440: 2f 84 00 00 00 00 00 00 00 00 90 50 2e 04 91 50  /..........P...P
rx 00000450: 29 84 08 00 00 00 14 00 00 00 91 50 2d 84 08 00  )..........P-...
rx 00000460: 00 00 14 00 00 00 91 50 2f 84 ff ff 00 00 00 00  .......P/.......
rx 00000470: 00 00 91 50 2f 84 00 00 00 00 00 00 00 00 91 50  ...P/..........P
rx 00000480: 2f 84 00 00 00 00 00 00 00 00 91 50 2e 04 91 50  /..........P...P
rx 00000490: 10 ac 06 00 00 00 00 00 00 00 91 50 10 ac 06 00  ...........P....
rx 000004a0: 00 00 00 00 00 00 91 50 29 84 29 f0 00 00 01 00  .......P).).....
rx 000004b0: 00 00 91 50 2d 84 29 f0 00 00 01 00 00 00 91 50  ...P-.)........P
rx 000004c0: 2f 84 00 00 00 00 00 00 00 00 91 50 2e 04 92 50  /..........P...P
rx 000004d0: 29 84 1a f0 00 00 06 00 00 00 92 50 2d 84 1a f0  )..........P-...
rx 000004e0: 00 00 06 00 00 00 92 50 2f 84 01 00 5e 00 00 01  .......P/...^...
rx 000004f0: 00 00 92 50 2e 04 92 50 29 84 29 f0 00 00 01 00  ...P...P).).....
rx 00000500: 00 00 92 50 2d 84 29 f0 00 00 01 00 00 00 92 50  ...P-.)........P
rx 00000510: 2f 84 00 00 00 00 00 00 00 00 92 50 2e 04 92 50  /..........P...P
rx 00000520: 29 84 29 f0 00 00 01 00 00 00 92 50 2d 84 29 f0  ).)........P-.).
rx 00000530: 00 00 01 00 00 00 92 50 2f 84 00 00 00 00 00 00  .......P/.......
rx 00000540: 00 00 92 50 2e 04 92 50 29 84 19 f0 00 00 06 00  ...P...P).......
rx 00000550: 00 00 92 50 2d 84 19 f0 00 00 06 00 00 00 92 50  ...P-..........P
rx 00000560: 2f 84 01 00 5e 00 00 01 00 00 92 50 2e 04 93 50  /...^......P...P
rx 00000570: 29 84 10 f0 00 00 09 00 00 00 93 50 2d 84 10 f0  )..........P-...
rx 00000580: 00 00 09 00 00 00 93 50 2f 84 ff ff ff ff ff ff  .......P/.......
rx 00000590: 02 00 93 50 2f 84 03 00 00 00 00 00 00 00 93 50  ...P/..........P
rx 000005a0: 2e 04 95 50 29 84 10 f0 00 00 09 00 00 00 95 50  ...P)..........P
rx 000005b0: 2d 84 10 f0 00 00 09 00 00 00 95 50 2f 84 ff ff  -..........P/...
rx 000005c0: ff ff ff ff 02 00 95 50 2f 84 03 00 00 00 00 00  .......P/.......
rx 000005d0: 00 00 95 50 2e 04 f9 50 29 84 29 f0 00 00 01 00  ...P...P).).....
rx 000005e0: 00 00                                            ..
ath6kl: wmi rx id 4112 len 1500
wmi rx 00000000: 08 30 00 00 00 00 00 00 c9 17 2c 44 08 30 00 00
.0........,D.0..
wmi rx 00000010: cb 17 29 84 29 f0 00 00 01 00 00 00 cb 17 2d 84
..).).........-.
wmi rx 00000020: 29 f0 00 00 01 00 00 00 cb 17 2f 84 00 00 00 00
)........./.....
wmi rx 00000030: 00 00 00 00 cb 17 2e 04 cb 17 29 84 19 f0 00 00
..........).....
wmi rx 00000040: 06 00 00 00 cb 17 2d 84 19 f0 00 00 06 00 00 00
......-.........
wmi rx 00000050: cb 17 2f 84 01 00 5e 00 00 01 00 00 cb 17 2e 04
../...^.........
wmi rx 00000060: d0 17 29 84 29 f0 00 00 01 00 00 00 d0 17 2d 84
..).).........-.
wmi rx 00000070: 29 f0 00 00 01 00 00 00 d0 17 2f 84 00 00 00 00
)........./.....
wmi rx 00000080: 00 00 00 00 d0 17 2e 04 d2 17 29 84 29 f0 00 00
..........).)...
wmi rx 00000090: 01 00 00 00 d2 17 2d 84 29 f0 00 00 01 00 00 00
......-.).......
wmi rx 000000a0: d2 17 2f 84 00 00 00 00 00 00 00 00 d2 17 2e 04
../.............
wmi rx 000000b0: 84 18 29 84 29 f0 00 00 01 00 00 00 84 18 2d 84
..).).........-.
wmi rx 000000c0: 29 f0 00 00 01 00 00 00 84 18 2f 84 00 00 00 00
)........./.....
wmi rx 000000d0: 00 00 00 00 84 18 2e 04 84 18 29 84 08 00 00 00
..........).....
wmi rx 000000e0: 14 00 00 00 84 18 2d 84 08 00 00 00 14 00 00 00
......-.........
wmi rx 000000f0: 84 18 2f 84 ff ff 00 00 00 00 00 00 84 18 2f 84
../.........../.
wmi rx 00000100: 00 00 00 00 00 00 00 00 84 18 2f 84 00 00 00 00
........../.....
wmi rx 00000110: 00 00 00 00 84 18 2e 04 84 18 10 ac 06 00 00 00
................
wmi rx 00000120: 00 00 00 00 84 18 10 ac 06 00 00 00 00 00 00 00
................
wmi rx 00000130: 85 18 29 84 29 f0 00 00 01 00 00 00 85 18 2d 84
..).).........-.
wmi rx 00000140: 29 f0 00 00 01 00 00 00 85 18 2f 84 00 00 00 00
)........./.....
wmi rx 00000150: 00 00 00 00 85 18 2e 04 85 18 29 84 1a f0 00 00
..........).....
wmi rx 00000160: 06 00 00 00 85 18 2d 84 1a f0 00 00 06 00 00 00
......-.........
wmi rx 00000170: 85 18 2f 84 01 00 5e 00 00 01 00 00 85 18 2e 04
../...^.........
wmi rx 00000180: 86 18 29 84 29 f0 00 00 01 00 00 00 86 18 2d 84
..).).........-.
wmi rx 00000190: 29 f0 00 00 01 00 00 00 86 18 2f 84 00 00 00 00
)........./.....
wmi rx 000001a0: 00 00 00 00 86 18 2e 04 86 18 29 84 29 f0 00 00
..........).)...
wmi rx 000001b0: 01 00 00 00 86 18 2d 84 29 f0 00 00 01 00 00 00
......-.).......
wmi rx 000001c0: 86 18 2f 84 00 00 00 00 00 00 00 00 86 18 2e 04
../.............
wmi rx 000001d0: 86 18 29 84 19 f0 00 00 06 00 00 00 86 18 2d 84
..)...........-.
wmi rx 000001e0: 19 f0 00 00 06 00 00 00 86 18 2f 84 01 00 5e 00
........../...^.
wmi rx 000001f0: 00 01 00 00 86 18 2e 04 87 18 29 84 10 f0 00 00
..........).....
wmi rx 00000200: 09 00 00 00 87 18 2d 84 10 f0 00 00 09 00 00 00
......-.........
wmi rx 00000210: 87 18 2f 84 ff ff ff ff ff ff 02 00 87 18 2f 84
../.........../.
wmi rx 00000220: 03 00 00 00 00 00 00 00 87 18 2e 04 87 18 29 84
..............).
wmi rx 00000230: 10 f0 00 00 09 00 00 00 87 18 2d 84 10 f0 00 00
..........-.....
wmi rx 00000240: 09 00 00 00 87 18 2f 84 ff ff ff ff ff ff 02 00
....../.........
wmi rx 00000250: 87 18 2f 84 03 00 00 00 00 00 00 00 87 18 2e 04
../.............
wmi rx 00000260: 13 19 29 84 29 f0 00 00 01 00 00 00 13 19 2d 84
..).).........-.
wmi rx 00000270: 29 f0 00 00 01 00 00 00 13 19 2f 84 00 00 00 00
)........./.....
wmi rx 00000280: 00 00 00 00 13 19 2e 04 13 19 29 84 08 00 00 00
..........).....
wmi rx 00000290: 14 00 00 00 13 19 2d 84 08 00 00 00 14 00 00 00
......-.........
wmi rx 000002a0: 13 19 2f 84 ff ff 00 00 00 00 00 00 13 19 2f 84
../.........../.
wmi rx 000002b0: 00 00 00 00 00 00 00 00 13 19 2f 84 00 00 00 00
........../.....
wmi rx 000002c0: 00 00 00 00 13 19 2e 04 13 19 10 ac 06 00 00 00
................
wmi rx 000002d0: 00 00 00 00 14 19 10 ac 06 00 00 00 00 00 00 00
................
wmi rx 000002e0: d7 4f 29 84 29 f0 00 00 01 00 00 00 d7 4f 2d 84
.O).)........O-.
wmi rx 000002f0: 29 f0 00 00 01 00 00 00 d7 4f 2f 84 00 00 00 00
)........O/.....
wmi rx 00000300: 00 00 00 00 d7 4f 2e 04 d8 4f 29 84 1a f0 00 00
.....O...O).....
wmi rx 00000310: 06 00 00 00 d8 4f 2d 84 1a f0 00 00 06 00 00 00
.....O-.........
wmi rx 00000320: d8 4f 2f 84 01 00 5e 00 00 01 00 00 d8 4f 2e 04
.O/...^......O..
wmi rx 00000330: d8 4f 29 84 29 f0 00 00 01 00 00 00 d8 4f 2d 84
.O).)........O-.
wmi rx 00000340: 29 f0 00 00 01 00 00 00 d8 4f 2f 84 00 00 00 00
)........O/.....
wmi rx 00000350: 00 00 00 00 d8 4f 2e 04 d8 4f 29 84 12 00 00 00
.....O...O).....
wmi rx 00000360: 01 00 00 00 d8 4f 2d 84 12 00 00 00 01 00 00 00
.....O-.........
wmi rx 00000370: d8 4f 2f 84 02 00 00 00 00 00 00 00 d8 4f 2e 04
.O/..........O..
wmi rx 00000380: d9 4f 29 84 29 f0 00 00 01 00 00 00 d9 4f 2d 84
.O).)........O-.
wmi rx 00000390: 29 f0 00 00 01 00 00 00 d9 4f 2f 84 00 00 00 00
)........O/.....
wmi rx 000003a0: 00 00 00 00 d9 4f 2e 04 d9 4f 29 84 19 f0 00 00
.....O...O).....
wmi rx 000003b0: 06 00 00 00 d9 4f 2d 84 19 f0 00 00 06 00 00 00
.....O-.........
wmi rx 000003c0: d9 4f 2f 84 01 00 5e 00 00 01 00 00 d9 4f 2e 04
.O/...^......O..
wmi rx 000003d0: e0 4f 29 84 29 f0 00 00 01 00 00 00 e0 4f 2d 84
.O).)........O-.
wmi rx 000003e0: 29 f0 00 00 01 00 00 00 e0 4f 2f 84 00 00 00 00
)........O/.....
wmi rx 000003f0: 00 00 00 00 e0 4f 2e 04 e1 4f 29 84 29 f0 00 00
.....O...O).)...
wmi rx 00000400: 01 00 00 00 e1 4f 2d 84 29 f0 00 00 01 00 00 00
.....O-.).......
wmi rx 00000410: e1 4f 2f 84 00 00 00 00 00 00 00 00 e1 4f 2e 04
.O/..........O..
wmi rx 00000420: 90 50 29 84 29 f0 00 00 01 00 00 00 90 50 2d 84
.P).)........P-.
wmi rx 00000430: 29 f0 00 00 01 00 00 00 90 50 2f 84 00 00 00 00
)........P/.....
wmi rx 00000440: 00 00 00 00 90 50 2e 04 91 50 29 84 08 00 00 00
.....P...P).....
wmi rx 00000450: 14 00 00 00 91 50 2d 84 08 00 00 00 14 00 00 00
.....P-.........
wmi rx 00000460: 91 50 2f 84 ff ff 00 00 00 00 00 00 91 50 2f 84
.P/..........P/.
wmi rx 00000470: 00 00 00 00 00 00 00 00 91 50 2f 84 00 00 00 00
.........P/.....
wmi rx 00000480: 00 00 00 00 91 50 2e 04 91 50 10 ac 06 00 00 00
.....P...P......
wmi rx 00000490: 00 00 00 00 91 50 10 ac 06 00 00 00 00 00 00 00
.....P..........
wmi rx 000004a0: 91 50 29 84 29 f0 00 00 01 00 00 00 91 50 2d 84
.P).)........P-.
wmi rx 000004b0: 29 f0 00 00 01 00 00 00 91 50 2f 84 00 00 00 00
)........P/.....
wmi rx 000004c0: 00 00 00 00 91 50 2e 04 92 50 29 84 1a f0 00 00
.....P...P).....
wmi rx 000004d0: 06 00 00 00 92 50 2d 84 1a f0 00 00 06 00 00 00
.....P-.........
wmi rx 000004e0: 92 50 2f 84 01 00 5e 00 00 01 00 00 92 50 2e 04
.P/...^......P..
wmi rx 000004f0: 92 50 29 84 29 f0 00 00 01 00 00 00 92 50 2d 84
.P).)........P-.
wmi rx 00000500: 29 f0 00 00 01 00 00 00 92 50 2f 84 00 00 00 00
)........P/.....
wmi rx 00000510: 00 00 00 00 92 50 2e 04 92 50 29 84 29 f0 00 00
.....P...P).)...
wmi rx 00000520: 01 00 00 00 92 50 2d 84 29 f0 00 00 01 00 00 00
.....P-.).......
wmi rx 00000530: 92 50 2f 84 00 00 00 00 00 00 00 00 92 50 2e 04
.P/..........P..
wmi rx 00000540: 92 50 29 84 19 f0 00 00 06 00 00 00 92 50 2d 84
.P)..........P-.
wmi rx 00000550: 19 f0 00 00 06 00 00 00 92 50 2f 84 01 00 5e 00
.........P/...^.
wmi rx 00000560: 00 01 00 00 92 50 2e 04 93 50 29 84 10 f0 00 00
.....P...P).....
wmi rx 00000570: 09 00 00 00 93 50 2d 84 10 f0 00 00 09 00 00 00
.....P-.........
wmi rx 00000580: 93 50 2f 84 ff ff ff ff ff ff 02 00 93 50 2f 84
.P/..........P/.
wmi rx 00000590: 03 00 00 00 00 00 00 00 93 50 2e 04 95 50 29 84
.........P...P).
wmi rx 000005a0: 10 f0 00 00 09 00 00 00 95 50 2d 84 10 f0 00 00
.........P-.....
wmi rx 000005b0: 09 00 00 00 95 50 2f 84 ff ff ff ff ff ff 02 00
.....P/.........
wmi rx 000005c0: 95 50 2f 84 03 00 00 00 00 00 00 00 95 50 2e 04
.P/..........P..
wmi rx 000005d0: f9 50 29 84 29 f0 00 00 01 00 00 00              .P).).......
ath6kl: WMI_EXTENSION_EVENTID
ath6kl: wmi event dbglog len 1496
ath6kl: ath6kl usb recv callback buf:0xbec21cc0
ath6kl: htc_try_send: (queue:0x  (null) depth:0)
ath6kl: get_htc_packet_credit_based: got head packet:0xbf184dc8 , queue depth: 1
ath6kl: get_htc_packet_credit_based: creds required:1 got:1
ath6kl: get_htc_packet_credit_based: host needs credits
ath6kl: htc_issue_packets: queue: 0xbf9b7e08, pkts 1
ath6kl: hif pipe send
ath6kl: +ath6kl_usb_send pipe : 0, buf:0xbec4d6c0
ath6kl: athusb bulk send submit:0, 0xC0008200 (ep:0x01), 32 bytes
ath6kl: Report indicated 1 credits to distribute
ath6kl: ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:32
ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf3fda80
ath6kl: ath6kl usb xmit callback buf:0xbec4d6c0
ath6kl: do_send_completion: calling ep 1, send complete multiple
callback (1 pkts)
ath6kl: ath6kl_tx_complete: skb=0xbec4d6c0 data=0xbf19cfbe len=0x1a eid=1 OK
ath6kl: ath6kl usb recv callback buf:0xbec21d80
ath6kl: Report indicated 1 credits to distribute





On Wed, Oct 30, 2013 at 8:05 PM, Drasko DRASKOVIC
<drasko.draskovic@gmail.com> wrote:
> HI all,
> I have AR6004 USB dongle connected to Linux kernel 3.10, and am
> testing latest hostapd.
>
> I noticed that I was able to put the dongle in the AP mode only for
> not-n mode (a or g).
>
> Enabling both of these options:
> hw_mode=g
> ieee80211n=1
>
> gives an error like this on starting:
>
> random: Trying to read entropy from /dev/random
> Configuration file: /home/drasko/hostapd.conf
> HT (IEEE 802.11n) with WPA/WPA2 requires CCMP/GCMP to be enabled,
> disabling HT capabilities
> rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
> rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
> rfkill: initial event: idx=2 type=2 op=0 soft=0 hard=0
> rfkill: initial event: idx=5 type=1 op=0 soft=0 hard=0
> nl80211: Using driver-based roaming
> nl80211: Supports Probe Response offload in AP mode
> nl80211: Disable use_monitor with device_ap_sme since no monitor mode
> support detected
> nl80211: interface wlan3 in phy phy3
> nl80211: Add own interface ifindex 6
> nl80211: Set mode ifindex 6 iftype 3 (AP)
> nl80211: Setup AP - device_ap_sme=1 use_monitor=0
> nl80211: Subscribe to mgmt frames with AP handle 0x1441480 (device SME)
> nl80211: Register frame type=0xd0 nl_handle=0x1441480
> nl80211: Register frame match - hexdump(len=0): [NULL]
> nl80211: Enable Probe Request reporting nl_preq=0x14414c0
> nl80211: Register frame type=0x40 nl_handle=0x14414c0
> nl80211: Register frame match - hexdump(len=0): [NULL]
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Regulatory information - country=FR
> nl80211: 2402-2482 @ 40 MHz
> nl80211: 2402-2482 @ 20 mBm
> nl80211: 5170-5250 @ 40 MHz
> nl80211: 5170-5250 @ 20 mBm
> nl80211: 5250-5330 @ 40 MHz
> nl80211: 5250-5330 @ 20 mBm
> nl80211: 5490-5710 @ 40 MHz
> nl80211: 5490-5710 @ 27 mBm
> nl80211: 57240-65880 @ 2160 MHz
> nl80211: 57240-65880 @ 40 mBm
> nl80211: Added 802.11b mode based on 802.11g information
> Completing interface initialization
> Mode: IEEE 802.11g  Channel: 7  Frequency: 2442 MHz
> DFS 0 channels required radar detection
> nl80211: Set freq 2442 (ht_enabled=1, vht_enabled=0, bandwidth=20 MHz,
> cf1=2442 MHz, cf2=0 MHz)
> nl80211: Failed to set channel (freq=2442): -22 (Invalid argument)
> Could not set channel for kernel driver
> wlan3: Unable to setup interface.
> wlan3: Flushing old station entries
> nl80211: flush -> DEL_STATION wlan3 (all)
> wlan3: Deauthenticate all stations
> nl80211: sta_remove -> DEL_STATION wlan3 ff:ff:ff:ff:ff:ff --> 0 (Success)
> wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
> key_idx=0 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
> key_idx=1 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
> key_idx=2 set_tx=0 seq_len=0 key_len=0
> wpa_driver_nl80211_set_key: ifindex=6 (wlan3) alg=0 addr=(nil)
> key_idx=3 set_tx=0 seq_len=0 key_len=0
> nl80211: Skip disabling of Probe Request reporting
> nl_preq=0x8888888889cc9c49 while in AP mode
> netlink: Operstate: linkmode=0, operstate=6
> nl80211: Set mode ifindex 6 iftype 2 (STATION)
> nl80211: Disable Probe Request reporting nl_preq=0x8888888889cc9c49
> nl80211: Unsubscribe mgmt frames handle 0x8888888889cc9c09 (AP
> teardown (dev SME))
> Failed to initialize interface
>
> I have tried several channels - all were rejected with the same message.
>
> Any idea where these error messages come from?
>
>
> Best regards,
> Drasko
