Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37782 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEWU5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 16:57:22 -0400
Received: by mail-ig0-f173.google.com with SMTP id hn18so1153324igb.6
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 13:57:21 -0700 (PDT)
Date: Fri, 23 May 2014 16:57:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@noack.us>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
Message-ID: <20140523205717.GB6585@localhost> (sfid-20140523_225725_523825_5510A876)
References: <3893194.GDQagdLGN9@desktop.local>
 <20140522192720.GA13440@localhost>
 <CAGnRvuqUkebLhvqY1Y28NtRyp3uUdbrpOSb4dOX2+ZSg6qineg@mail.gmail.com>
 <CAEFj9850c9aD5gKz2B-e=hPnS2vNdY+a4uc9D_+psryE0ywDVA@mail.gmail.com>
 <CAGnRvuo_ydU-HwtyTeKP50GPjEiNQy1EoVMR5_Dg-qTrFjYkPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnRvuo_ydU-HwtyTeKP50GPjEiNQy1EoVMR5_Dg-qTrFjYkPg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 23, 2014 at 12:52:57PM +0200, Henning Rogge wrote:
> Hi,
> 
> I will have another look at the codebase next week, there was a lot of
> similar code for both tables that could be simplified without throwing
> them together.
> 
> The feeling I get here is that four new nl80211 commands
> (set/get/del/dump mpp_paths) are the right way to export these values?

That approach would be fine by me.  Thanks for working on this!

-- 
Bob Copeland %% www.bobcopeland.com
