Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:36682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYCaWKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 18:10:33 -0400
Received: by fg-out-1718.google.com with SMTP id l27so2057129fgb.17
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 15:10:32 -0700 (PDT)
To: "Felipe Maya" <fmay@cetuc.puc-rio.br>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Tue, 1 Apr 2008 00:10:15 +0200
Cc: linux-wireless@vger.kernel.org
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
In-Reply-To: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804010010.15705.IvDoorn@gmail.com> (sfid-20080331_231038_030206_DDF1A560)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Is the last kernel code working with RaLink RT2500 802.11g Cardbus/mini-PCI?

With 'latest' do you mean:
 latest 2.6.25-rc kernel?
 latest wireless-testing git snapshot
 latest rt2x00 git snapshot

The latter 2 should work fine, the first one has known issues
but the state variates per person.

> In my machine don't work, but with the serialmonkey driver is well.
> 
> (http://rt2x00.serialmonkey.com/rt2500-cvs-daily.tar.gz)
> 
> Somebody can help me to configure the rt2x00 driver in order to run
> ieee80211 module.

How are you configuring the interface?
What tools are you using?
Do you get error messages?
Is there any other information that might be usefull for understanding this bug?

Ivo
