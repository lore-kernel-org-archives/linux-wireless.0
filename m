Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44161 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0KUHL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 02:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinfF6yN_9YJ4=1u_O_3-c+aptLuuK=Z=g67fBsa@mail.gmail.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
	<20101118164552.GC2855@kroah.com>
	<AANLkTing6JkfH=n2GfWtW+2=5oB40FDM-TYPvzd+PPkH@mail.gmail.com>
	<AANLkTi=QdfdhVcK2tddsaLYzatJEr6KRRoU5pMqKZwte@mail.gmail.com>
	<AANLkTinfF6yN_9YJ4=1u_O_3-c+aptLuuK=Z=g67fBsa@mail.gmail.com>
Date: Sun, 21 Nov 2010 15:11:24 +0800
Message-ID: <AANLkTimc3wfC3m9Z8Ssbxgo_N72PY8VVhnwK8ExvMhCq@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
From: Adrian Chadd <adrian@freebsd.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	Charles Marker <Charles.Marker@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Don Breslin <Don.Breslin@atheros.com>,
	Doug Dahlby <Doug.Dahlby@atheros.com>,
	Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2010 13:53, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:

>> * decoupling the hardware twiddling stuff from OS/802.11 stack
>> specific stuff is helpful;
>
> ath9k_hw mostly is 802.11 stack independent except band enum usage,
> and maybe one other variable we stuffed in there to help clean out
> code more.

Yup, I saw that.


> Agreed. Thanks for your feedback.

No worries. You'll get more feedback when I come to actually trying to
port the AR9003 hwops code over.
As I said, I'll have a bit of a practice run soon with some of the
kite/merlin calibration stuff that isn't yet in FreeBSD.


Adrian
