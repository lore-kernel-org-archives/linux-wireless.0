Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52906
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965702AbXHMMTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 08:19:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH][SSB] Fix a warning in PCI core driver
Date: Mon, 13 Aug 2007 14:18:39 +0200
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070812235058.GA4966@hall.aurel32.net> <200708130421.31904.mb@bu3sch.de> <20070813090710.GA25439@hall.aurel32.net>
In-Reply-To: <20070813090710.GA25439@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708131418.39929.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 August 2007 11:07:10 Aurelien Jarno wrote:
> On Mon, Aug 13, 2007 at 04:21:31AM +0200, Michael Buesch wrote:
> > > Yes it is overflow warning. The compiler thinks that those constant are
> > > signed values and thus generate an overflow.
> > > 
> > > Another fix would be to postfix those constants by U.
> > > 
> > 
> > Can you please do this?
> > 
> 
> Please find a patch below. I did the same for the whole address map for
> consistency.
> 
> Aurelien

Queued, thanks!

-- 
Greetings Michael.
