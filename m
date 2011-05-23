Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:33150 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab1EWG71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 02:59:27 -0400
Message-ID: <4DDA05C9.7090306@create-net.org> (sfid-20110523_085930_225480_F1C3FD01)
Date: Mon, 23 May 2011 08:59:21 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: Matteo Croce <matteo@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2]: mac80211: set tx rate and retries when injecting
References: <BANLkTin6ettB1nhnrAjDncX1MrahfS4Z6g@mail.gmail.com> <4DD63D65.5060308@create-net.org> <BANLkTimJqQpimg3xZwORV89kukZcBVuhrQ@mail.gmail.com>
In-Reply-To: <BANLkTimJqQpimg3xZwORV89kukZcBVuhrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il 23/05/2011 02:30, Matteo Croce ha scritto:
>
> I'm not sure that the rate control is used in monitor mode
well, without that piece of code the frame is not injected. I'm talking
about 11a/g rates since for 11n rates I still did not manage
to have it working.
