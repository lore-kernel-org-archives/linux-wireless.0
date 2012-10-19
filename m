Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58826 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2JSSe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 14:34:57 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so592810wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2012 11:34:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D075EBFDE@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D075EBFDE@RockMX01.rock.corp>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 19 Oct 2012 11:34:35 -0700
Message-ID: <CAG6hwVNi7JgAaq_xZarQFhG=DjY0a8FcodeVaahmWGZkhCc3=A@mail.gmail.com> (sfid-20121019_203500_720354_0BE053C5)
Subject: Re: bug in mesh_sync_adjust_tbtt()
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lin,

On Fri, Oct 19, 2012 at 10:43 AM, Chaoxing Lin
<Chaoxing.Lin@ultra-3eti.com> wrote:
> I have checked a few kernel versions between 3.5 and 3.6.2, even the latest version 3.6.2 has the same problem.

Yes, this has been fixed in
https://patchwork.kernel.org/patch/1556391/. Unfortunately I forgot to
CC stable@kernel.org, so this fix won't make it in until 3.7.

Submitted to stable@vger.kernel.org and lesson (hopefully) learned.
This should be fixed in 3.6.3

Thanks,
Thomas
