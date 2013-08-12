Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51884 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3HLX1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 19:27:18 -0400
Received: by mail-ie0-f182.google.com with SMTP id tp5so9367850ieb.41
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 16:27:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <520968B0.80301@lwfinger.net>
References: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com>
	<520968B0.80301@lwfinger.net>
Date: Mon, 12 Aug 2013 16:27:18 -0700
Message-ID: <CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com> (sfid-20130813_012721_619208_99124F7E)
Subject: Re: issues with RTL8188CE device and rtl8192ce driver
From: Colleen Josephson <cjoseph@mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Have you tried the backports driver? There are a number of changes since
> 3.8, which you will access that way.

I had not tried the backports driver. Do I need remove support things
in my kernel that I am now compiling with backports?
