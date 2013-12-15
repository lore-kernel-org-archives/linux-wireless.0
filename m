Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:33895 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab3LOGAv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 01:00:51 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: wpa_supplicant and driver reload
From: Jouni Malinen <j@w1.fi>
In-Reply-To: <52A82A1D.80409@broadcom.com>
Date: Sat, 14 Dec 2013 21:46:50 -0800
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <2323CBC6-B7B3-49FF-882F-66B9F0B9A879@w1.fi> (sfid-20131215_070113_170345_F18FCBC1)
References: <52A82A1D.80409@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 11 Dec 2013, at 1:02 am, Arend van Spriel <arend@broadcom.com> wrote:

> A basic questionIn my testing I normally stop wpa_supplicant when reloading my driver and start it again, but I was wondering whether this is needed. Can wpa_supplicant deal with interface index change for the network interface?

Yes, it can.

(Did you not try it before asking? Or did it fail in some way?)

- Jouni

