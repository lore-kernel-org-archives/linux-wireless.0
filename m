Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43547 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbXI0SOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 14:14:31 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Iaxr1-0005oF-M3
	for linux-wireless@vger.kernel.org; Thu, 27 Sep 2007 18:12:51 +0000
Received: from 069-064-229-129.pdx.net ([69.64.229.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 18:12:51 +0000
Received: from shemminger by 069-064-229-129.pdx.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 18:12:51 +0000
To: linux-wireless@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: New 'Changes-licensed-under' tag introduced for Linux-wireless
Date: Thu, 27 Sep 2007 11:09:50 -0700
Message-ID: <20070927110950.0561eca1@freepuppy.rosehill>
References: <43e72e890709271100n39f16c18x723dc7a85d418666@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
In-Reply-To: <43e72e890709271100n39f16c18x723dc7a85d418666@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 27 Sep 2007 14:00:09 -0400
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> Our guidelines for patches [1] for Linux-wireless has been updated.
> One section asks Linux-wireless developers to subscribe to the patch
> guideline wiki page (section 2) and another which introduces the new
> 'Changes-licensed-under' (section 10).
> 
> Here I'll cover the new 'Changes-licensed-under' tag but please refer
> to the link and subscribe to the page for the complete details and for
> further changes.
> 

No, please don't down this legal rat hole. It would cause bullshit like
people submitting dual licensed patches to the scheduler or GPL only
patches to the ath5k or ACPI code.

Instead, add a section to Documentation/SubmittingPatches that clearly
states that all changes to a file are licensed under the same license
as the original file. I don't feel legally qualified to write the correct
wording.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

