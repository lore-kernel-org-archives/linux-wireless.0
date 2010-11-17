Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54222 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab0KQVMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:12:40 -0500
Received: by vws13 with SMTP id 13so1341938vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 13:12:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik_4HRwUUYnFLR6BwevQi6W+FK2rNN7Kph+dAWk@mail.gmail.com>
References: <AANLkTik_4HRwUUYnFLR6BwevQi6W+FK2rNN7Kph+dAWk@mail.gmail.com>
Date: Wed, 17 Nov 2010 16:12:33 -0500
Message-ID: <AANLkTikda-CP42-_wnNtEpCJGc3kwNXvT0KgXjOOL+Bc@mail.gmail.com>
Subject: Re: Unloading ath5k fails
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 12:32 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> Hi all,
>
> I'm not sure if this is a problem with ath5k, or with wireless-testing
> in general. We have a fresh build of today's git pull. When trying to
> unload ath5k with the interface still up, the rmmod command fails and
> goes into a 'zombie' state with the following error coming up every 5s
> or so:
> unregister_netdevice: waiting for wlan0 to become free. Usage count = 1


Hmm.. I just ran some tests myself on wireless-testing, with ath5k
connected and not connected and didn't have any problems.  Are you
doing anything special when bringing up the interface?  Can you
post your kernel config?

I take it this is a recent regression; if all else fails you can
try bisecting it.

-- 
Bob Copeland %% www.bobcopeland.com
