Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59908 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbYCBU02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 15:26:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-02-27
Date: Sun, 2 Mar 2008 21:25:15 +0100
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>
References: <20080228014125.GI3078@tuxdriver.com> <20080302115828.GA15820@uranus.ravnborg.org> <97a0a9ac0803021200v117379b6x1c4bc0f8ae580040@mail.gmail.com>
In-Reply-To: <97a0a9ac0803021200v117379b6x1c4bc0f8ae580040@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803022125.15933.mb@bu3sch.de> (sfid-20080302_202632_619000_41E0E082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 02 March 2008 21:00:23 Gordon Farquharson wrote:
> Hi Sam
> 
> On Sun, Mar 2, 2008 at 4:58 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> >  Find below a patch that detect when we do a cross build and thus ignore
> >  the check.
> 
> Works for me.
> 
> Tested-by: Gordon Farquharson <gordonfarquharson@gmail.com>

The patch looks good. I suggest Andrew pull it for some time into
the -mm tree and then pushes it forward to Linus for 2.6.25.

You can add an Acked-by: Michael Buesch <mb@bu3sch.de>
although I can not runtime test it here.

-- 
Greetings Michael.
