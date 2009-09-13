Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33925 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZIMTEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2009 15:04:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Problem with compat-wireless build
Date: Sun, 13 Sep 2009 21:04:21 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4AAD05D5.4030606@lwfinger.net>
In-Reply-To: <4AAD05D5.4030606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909132104.23129.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 September 2009 16:46:45 Larry Finger wrote:
> In the link at
> http://ubuntuforums.org/showpost.php?p=7940247&postcount=92, a problem
> with building compat-wireless on 2.6.28 is described. A posting on the
> openSUSE forum states that this started with the 06-09-2009 release.
> From the error message, it is due to the threaded interrupt code in
> b43. That may be difficult to fix as this change exposed a
> long-standing kernel bug that also needed to be fixed.

I already posted a compat layer for this to the list. Mcgrof is going
to merge that after all my other patches hit compat-wireless.

-- 
Greetings, Michael.
