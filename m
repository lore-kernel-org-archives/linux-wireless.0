Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42768 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2HMTAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 15:00:14 -0400
Date: Mon, 13 Aug 2012 14:47:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>
Subject: Re: [PATCH] Revert "rfkill: remove dead code"
Message-ID: <20120813184749.GC10529@tuxdriver.com> (sfid-20120813_210020_999383_42C25649)
References: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
 <CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com>
 <CAMz9Wg8a0rAj8FN4gczfB6aUA8KgAiTc0_MG6Vc046Zmo4o0Tw@mail.gmail.com>
 <CAGRGNgX+QmoYhkPuPrr_c5TvqRP=hhzxOSftZh969aOFeiV28g@mail.gmail.com>
 <CAMz9Wg8eMTJcmd5tcxBURP3Rmuu4siEFTBDqW1aK8rqdZ8utqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMz9Wg8eMTJcmd5tcxBURP3Rmuu4siEFTBDqW1aK8rqdZ8utqA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this all sorted?  Is this patch going through the platform tree?

On Thu, Jul 26, 2012 at 02:19:23PM +0800, AceLan Kao wrote:
> Dear Julian,
> 
> Yes, I have said that the asus-wmi patch needs this commit
> and CC'd the asus-wmi maintainer, Corentin Chary, here in this rfkill patch.
> 
> Best regards,
> AceLan Kao.
> 
> 2012/7/26 Julian Calaby <julian.calaby@gmail.com>:
> > Hi AceLan,
> >
> > On Thu, Jul 26, 2012 at 3:55 PM, AceLan Kao <acelan.kao@canonical.com> wrote:
> >> Dear Julian,
> >>
> >> I just submitted a patch to platform-x86 for asus-wmi.
> >> And the patch needs to use rfkill_set_led_trigger_name() function
> >> to bind the wlan led to rfkill event.
> >
> > That's what I wanted to know.
> >
> > I assume that you've added a note to the ASUS-WMI patch so people know
> > that it needs this one first. (I can't see it here so I don't know)
> >
> > Thanks,
> >
> > --
> > Julian Calaby
> >
> > Email: julian.calaby@gmail.com
> > Profile: http://www.google.com/profiles/julian.calaby/
> > .Plan: http://sites.google.com/site/juliancalaby/
> 
> 
> 
> -- 
> Chia-Lin Kao(AceLan)
> http://blog.acelan.idv.tw/
> E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
