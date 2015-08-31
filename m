Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:35291 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbHaLjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 07:39:08 -0400
Received: by vkaw128 with SMTP id w128so36465413vka.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 04:39:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 31 Aug 2015 13:39:07 +0200
Message-ID: <CAAfyv36YLsEVarY6J8H-=Vcox=ktgeCUkqurHnAXzj_UFfthYw@mail.gmail.com> (sfid-20150831_133912_387342_AE08C919)
Subject: kernel log flooded with GET_CMD_NODE: cmd node not available
From: Belisko Marek <marek.belisko@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm running kernel 4.1 (no code changes in mwifiex) on custom board
with mwrvl sd8787 sdio wifi card. Everything works fine but when I
start hostapd and connect to device from PC  and open device webpage I
can see in log many of such messages (~100 same lines):
GET_CMD_NODE: cmd node not available
PREP_CMD: no free cmd node

I'm using fw: 14.66.35.p25

With 3.19 kernel I cannot see any of such messages. Any ideas? Thanks.

BR,

marek
-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
