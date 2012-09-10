Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64268 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2IJKxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 06:53:50 -0400
Received: by ieje11 with SMTP id e11so2784931iej.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 03:53:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPc5KCfy6xTNSuVfNHbqJP0pP+RuMMneG3-VPz9CMMrxqr8eXw@mail.gmail.com>
References: <CAPc5KCfvAfq7Cj0nptxLDGVHOzsLj0QADfs5r2j1taEZGJOQQQ@mail.gmail.com>
 <CAPc5KCfy6xTNSuVfNHbqJP0pP+RuMMneG3-VPz9CMMrxqr8eXw@mail.gmail.com>
From: Frank Knaesel <frank@knaesel.com>
Date: Mon, 10 Sep 2012 11:53:29 +0100
Message-ID: <CAPc5KCe_Q7M_XXA4O-p3DNLOxHFzHm9RSffv5SZ4zo-iJvt7yQ@mail.gmail.com> (sfid-20120910_125353_087539_D574ADEE)
Subject: Burst Frame sending and Block Ack
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello guys,

I'm new to kernel development and sorry for naive/dummy questions in here.
I'm doing a research on sending frames in bursts and get/set the block
acknowIedgement frames.
Can you please give a direction on how can I do this ?
1) Is it possible to do it on user space for 802.11b/g ? If possible,
please, how can I do that ?
2) If not possible to do it on user space, which files should I look
for to implement this feature ?

Kindest regards, Frank.
