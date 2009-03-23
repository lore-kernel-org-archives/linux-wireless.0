Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:57112 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZCWS6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 14:58:34 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2965184wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 11:58:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237682473-5994-1-git-send-email-tuliom@gmail.com>
References: <1237682473-5994-1-git-send-email-tuliom@gmail.com>
Date: Mon, 23 Mar 2009 14:58:32 -0400
Message-ID: <b6c5339f0903231158n7f51c78cnf895a7ba8010b7a2@mail.gmail.com> (sfid-20090323_195841_898196_3DC5EA73)
Subject: Re: [PATCH] ath5k: Support LED's on Acer Extensa 5620z
From: Bob Copeland <me@bobcopeland.com>
To: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 21, 2009 at 8:41 PM, Tulio Magno Quites Machado Filho
<tuliom@gmail.com> wrote:
> Add vendor ID for Quanta Microsystems and update the led table with the reported device.
>
> Reported-by: Scott Barnes <nekoreeve@gmail.com>
>
> Signed-off-by: Tulio Magno Quites Machado Filho <tuliom@gmail.com>

Acked-by: Bob Copeland <me@bobcopeland.com>

I have another one to send, for the "Fukato Datacask Jupiter" but I
couldn't figure out who owns the subvendor ID (0x1a3b).  I guess I'll
assume it is Fukato unless anyone knows a reliable source for looking
those up besides Google...

-- 
Bob Copeland %% www.bobcopeland.com
