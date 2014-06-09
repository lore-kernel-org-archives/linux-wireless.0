Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47724 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaFIRlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 13:41:24 -0400
Received: by mail-ve0-f179.google.com with SMTP id oy12so6787833veb.24
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2014 10:41:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402331489.7405.2.camel@dcbw.local>
References: <1402176137-8485-1-git-send-email-jahnavi.meher@gmail.com>
	<1402331489.7405.2.camel@dcbw.local>
Date: Mon, 9 Jun 2014 23:11:23 +0530
Message-ID: <CAPD+p4JzTu80f7GzMXn1K-dMioM7XcUCuDwYUMra6NADphkz=Q@mail.gmail.com> (sfid-20140609_194131_608855_572A99DF)
Subject: Re: [PATCH 2/4] rsi: Adding support for 5GHz
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,
I had noticed this today itself and was wondering if I should send in
another series of patches. I made an error while stripping off some
additional code for 40MHz. The value does get over written in
rsi_program_bb_rf(), which is why it did not show up while testing.
The endpoint for 5GHz with 20MHz bandwidth is 2.
