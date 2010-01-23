Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35343 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0AWSce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:32:34 -0500
Received: by yxe17 with SMTP id 17so1843387yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 10:32:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100123134005.GA11322@progeny.tock>
References: <20100123105111.GA24790@progeny.tock>
	 <fe54d8c01001230418u3de7f4ccuc4fbfdecc7c76ebf@mail.gmail.com>
	 <20100123134005.GA11322@progeny.tock>
Date: Sat, 23 Jan 2010 13:32:32 -0500
Message-ID: <b6c5339f1001231032r155b380av93563a6febeeae2b@mail.gmail.com>
Subject: Re: ath5k phy0: unsupported jumbo
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Kacper <kacper@kacper.se>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2010 at 8:40 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> So it looks like we receive some strange packets that haven’t been
> explained yet.  It might be worth looking at a few --- sounds kind of
> interesting.
>
> Am I understanding correctly?  This is a hardware bug or undocumented
> hardware feature then, right?
>
> It might be nice to add some user-oriented explanation too, but for
> now, how about this comment?
>

That's ok with me.  I'd also be fine with removing the log spam.  I think
ultimately it represents some kind of driver issue, I'm just not sure what,
exactly, yet.  I recently added more debugging to a kernel on a system of
mine that produces it more often -- I'll see what it turns up.

-- 
Bob Copeland %% www.bobcopeland.com
