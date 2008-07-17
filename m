Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59154 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbYGQLyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 07:54:43 -0400
Date: Thu, 17 Jul 2008 08:54:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [GIT PATCH] rfkill fixes, set 2
Message-ID: <20080717115438.GA31732@khazad-dum.debian.net> (sfid-20080717_135447_355353_33F73586)
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216225764.21973.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216225764.21973.8.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 16 Jul 2008, Dan Williams wrote:
> > Please consider for merging for 2.6.26, as they are fixes and not
> > enhancements.  Ivo, please be specially hard on the last patch, I did
> > test it here, but locking is always tricky...
> 
> If you do really mean 2.6.26, that's out already so you'd want to send
> the patches to stable@ as well.  But I assume you mean 2.6.27, right?

Yeah, it is 2.6.27.  Sorry about that.  I don't think these patches are
needed in 2.6.26 at all, it is not like we have ever seen issues with rfkill
in the wild anyway, and it doesn't have very much widespread use yet.

I consider that promoting something to -stable is Ivo's call, really.  But
if I ever happen to find a NULL derrefernce or something like that, I will
be sure to ask about it just as a head's up.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
