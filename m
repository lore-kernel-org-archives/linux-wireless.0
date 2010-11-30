Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40351 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0K3XW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 18:22:59 -0500
Received: by iwn10 with SMTP id 10so324424iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 15:22:58 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Nov 2010 15:22:38 -0800
Message-ID: <AANLkTikaRWrDa9B3bg2SdddKiB9sqw8TefKmF-EhDeoL@mail.gmail.com>
Subject: Re: compat-wireless for 2.6.21
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 3:07 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> I have a separate question about compat-wireless. I need to backport to kernel
> 2.6.21.

Neat

> I have fixed most of the problems, but I'm stuck on the case where
> something has been added to a struct since that kernel. I looked at all the
> compat-XXX patches, but I don't see what has been done previously. Is that
> written up somewhere, or is there a prescription?

Structural changes typically require a respective foo.patch to ifdef
around it. You get bonus points if you figure out a way to reduce the
mount of the hunks though and a Mushroom and Extra life if you get it
into compat.git instead.

 Luis
