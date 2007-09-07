Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51403.mail.re2.yahoo.com ([206.190.38.182]:48877 "HELO
	web51403.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964945AbXIGI1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 04:27:35 -0400
Date: Fri, 7 Sep 2007 01:20:53 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: request for information about the "ath5k" licensing
To: linux-wireless@vger.kernel.org, Reyk Floeter <reyk@openbsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <302924.76562.qm@web51403.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reyk Floeter wrote:
> I'm still waiting for an answer. Your process is taking too long.
> 
> Reyk

Reyk (and everybody else),
I'm writing as a silent observer, not as an involved (until now) party. I will restrict my answer mostly to links to information I consider key facts of this whole affair:

The development of the Linux Atheros driver (both for the official Atheros HAL and your work) takes place at www.madwifi.org. The SVN branch based on openhal can be found here:
http://madwifi.org/browser/branches/ath5k
Going back in the version history you WILL find revisions with the changed license. This mistake has been corrected in revision 2699.

The patches from the openhal team at madwifi.org have been merged into the "official" Linux wireless repository. You can find the branch that includes the ath5k driver here:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=summary
the ath5k files are here:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=tree;f=drivers/net/wireless;h=2d6caeba0924c34b9539960b9ab568ab3d193fc8;hb=everything
(look for the ath5k files). Going back in the revision history you will find, that the proposed license changes where never applied:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=history;f=drivers/net/wireless/ath5k_hw.c;h=07ad1278b39037caf68825cabcf9469db059dfc8;hb=everything

The mail that started this affair was:
http://marc.info/?l=linux-wireless&m=118831729905625&w=2

If you follow this thread, you will see, that the obvious problems were immediately flagged in the review process.

Next thing: While the proposed change was obviously bad, it *SEEMS* that this was a honest mistake. The following mail
by Sam Leffler suggest, that Jiri Slaby tried to get the consent of the *BSD developers:
http://article.gmane.org/gmane.linux.kernel.wireless.general/5305

Most of the ensuing flame war centered around whether it was illegal to change the license of those dual licensed files. Alan Cox stated in
http://article.gmane.org/gmane.linux.network/70533
"So whats the problem ?"
Theo de Raadt in http://thread.gmane.org/gmane.os.openbsd.misc/127782
wrote "Alan asks "So whats the problem ?".  Well, Alan, I must caution you -- your post is advising people to break the law."

This made a lot of people upset and the whole thing went out of hand.

It was more or less finally settled with the following mail:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/5303

This affair *NEVER* came close to what one would consider the official Linux repository, e.g. Linus tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary

And for Linus' position to BSD vs. GPL in drivers is summarized here:
http://article.gmane.org/gmane.linux.kernel.wireless.general/5452

Kind regards
  Joerg
 
--  
Regards
 
       Joerg
 






      Machen Sie Yahoo! zu Ihrer Startseite. Los geht's: 
http://de.yahoo.com/set
