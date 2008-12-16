Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:33196 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYLPDaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 22:30:13 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2997450wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 19:30:12 -0800 (PST)
Message-ID: <4ef93a380812151930nef6e3e2j68b9cd2ebae08e87@mail.gmail.com> (sfid-20081216_043018_607575_4133D6BC)
Date: Mon, 15 Dec 2008 22:30:12 -0500
From: "Jeongki Min" <jeongkimin@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Question about queue parameter change
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


My name is Jeong Ki Min who would like to work on the ath5k driver for
Atheros chipset.

I'm reading code for ath5k driver In this directory:
"compat-wireless-2008-12-11/drivers/net/wireless/ath5k/".

And in this fuction "ath5k_txq_setup" of base.c, I saw that cwmin,
cwmax, and aifs values are set by calling "ath5k_hw_setup_tx_queue"
function.


Here's my question.

When a node is transmitting packets, can I suddenly change the queue
parameters like cwmin, cwmax, and aifs values?

If yes, do those new parameters can affect some packets in hardware
queue? (I mean some packet which are already placed in a queue are
sent by new queue values?)
is there any thing I need to make sure beside calling
"ath5k_hw_setup_tx_queue" function?

If no, is there any other methods for above idea?


I would really appreciate it if you would give me any your comment on this.


Thanks,
JK
