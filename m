Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49101 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0CIGp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 01:45:59 -0500
Received: by gyh3 with SMTP id 3so1246388gyh.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 22:45:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003091456.37577.br1@einfach.org>
References: <20100308025841.7460.69949.stgit@void>
	 <b6c5339f1003081910t745c3e5ftafbedd1298487875@mail.gmail.com>
	 <43e72e891003081932h49340b6aia3fb6fd1e60ae8d7@mail.gmail.com>
	 <201003091456.37577.br1@einfach.org>
Date: Tue, 9 Mar 2010 01:45:58 -0500
Message-ID: <b6c5339f1003082245j2ef6ada1ka454cc379b26a695@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: fix I/Q calibration (for real)
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 9, 2010 at 12:56 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Tuesday 09 March 2010 12:32:33 Luis R. Rodriguez wrote:
>> Perhaps a little more elaboration on the commit log on the impact and
>> how this helps and how much would help.
>
> ok. to stop the confusion, i'll add cc: stable.

:) thanks!

FWIW, I tested the patches, and they worked well for my not-very-thorough
tests.  I think there was a regression in 2.6.32 time-frame that I never
pinned down, hopefully this corrects some things.  I did not test the 5211
stuff though, that one patch is probably not for stable unless someone can
test that.

-- 
Bob Copeland %% www.bobcopeland.com
