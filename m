Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42164 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1BNK6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:58:00 -0500
Received: by yxt3 with SMTP id 3so1988268yxt.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 02:57:59 -0800 (PST)
From: Jordi Pujol <jordipujolp@gmail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: synchronize transmission routines
Date: Mon, 14 Feb 2011 11:57:51 +0100
Cc: linux-wireless@vger.kernel.org
References: <201102131531.29984.jordipujolp@gmail.com> <201102141047.48790.jordipujolp@gmail.com> <AANLkTik0rEeK6qSc7rWxqDKicdNDEaH=ne+ODS+WwHQx@mail.gmail.com>
In-Reply-To: <AANLkTik0rEeK6qSc7rWxqDKicdNDEaH=ne+ODS+WwHQx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102141157.51656.jordipujolp@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A Dilluns 14 Febrer 2011 10:54:17, Ivo Van Doorn va escriure:
> >> Both rxdone as txdone are for USB devices on a singlethreaded
> >> workqueue. So it the work items will be scheduled only once...

guess (maybe) the problem is in the usb workqueues, I have found also an 
erratic behaviour in the usb mouse.

> Could you try the compat-wireless package? There are a lot
> of queue-related patches in there which were submitted after 2.6.37.

this afternoon will try that,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com
