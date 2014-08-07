Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37408 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaHGPEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 11:04:08 -0400
Received: by mail-ob0-f177.google.com with SMTP id wp18so2924214obc.22
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 08:04:08 -0700 (PDT)
Message-ID: <53E39565.906@lwfinger.net> (sfid-20140807_170416_429816_DB25B3E5)
Date: Thu, 07 Aug 2014 10:04:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bug 1239578 <1239578@bugs.launchpad.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Bug 1239578] Re: No wireless support for Realtek RTL8192EE [10ec:818b]
References: <20131014084701.27758.65697.malonedeb@chaenomeles.canonical.com> <20140807054245.23623.42169.malone@wampee.canonical.com>
In-Reply-To: <20140807054245.23623.42169.malone@wampee.canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/07/2014 12:42 AM, Yu Leng wrote:
> Thank you Larry for posting the latest driver code. I am no where close
> to the expertise most people have on this forum. This is may well be a
> beginner question. Do I just git clone your repo, do "make", "make
> install" and then reboot?

You are close. Building code should always be done as a regular user, not as
root. Thus the correct commands are "make" and "sudo make install".

Larry


