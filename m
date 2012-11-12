Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38097 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab2KLAUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 19:20:41 -0500
Date: Sun, 11 Nov 2012 16:10:34 -0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Need help with RTL8187SE staging driver
Message-ID: <20121112001034.GA1150@kroah.com> (sfid-20121112_012050_388960_BE1DC088)
References: <CAKErNvpyUxNxEMEt6gcVCr_3MTNpHaSU=5yZy2YsYmYOSCJLsw@mail.gmail.com>
 <CAKErNvq9O5d_vEQnBhD6PSy-gc37UfvhRA4nRh1r=xFSdC98Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKErNvq9O5d_vEQnBhD6PSy-gc37UfvhRA4nRh1r=xFSdC98Yw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 11, 2012 at 11:48:46PM +0200, Maxim Mikityanskiy wrote:
> (I'm sorry, mailing list rejected my previous letter, I'm resending)
> 
> Hello,
> 
> I've decided to refactor and improve rtl8187se kernel driver from
> staging directory, because it is buggy and lacks some features. It
> causes full system freeze after resume from suspend, there are some
> typos in interrupt handler that affect logic, it causes OOPS when
> rmmoding, it has not rfkill support, it uses private ieee80211 stack
> etc.
> 
> I'm writing to you, because your address is mentioned in
> drivers/staging/rtl8187se/TODO file. Also I'm CCing to linux-wireless
> mailing list in hope that there are people that could also help me.
> 
> You can clone git repository with modified driver source code here:
> git@bitbucket.org:gentoo_root/
> rtl8187se-staging.git. At first, I've removed some non-vital features
> and dead code from original driver in order to simplify code. Then
> I've fixed some bugs and created more clear structure of code. For
> now, I did not fully follow Linux kernel coding style, there are lots
> of long lines, and I hope to fix that later.

Why not send patches for this so we can get your cleanups and other dead
code removal changes into the tree to make your further changes easier?

thanks,

greg k-h
