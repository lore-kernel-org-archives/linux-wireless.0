Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47872
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbXJBVFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 17:05:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: What happened with z1211?
Date: Tue, 2 Oct 2007 23:02:33 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200710021147.55506.mb@bu3sch.de> <200710022239.09217.mb@bu3sch.de> <4702B1F7.3040100@gentoo.org>
In-Reply-To: <4702B1F7.3040100@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710022302.33638.mb@bu3sch.de> (sfid-20071002_220534_321275_37C8E115)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 October 2007 23:02:47 Daniel Drake wrote:
> Michael Buesch wrote:
> > When is that port going to happen then?
> > I mean, the drop of z1211 is a huge regression for me, as I am
> > using it in production environment.
> 
> We're aiming for 2.6.25. Right now zd1211rw-mac80211 does not really 
> provide any big user advantages over zd1211rw so you should be able to 
> use the existing driver until then.

Well, softmac is crap and has several race conditions that mac8021
does not have. That's the actual problem. ;)

-- 
Greetings Michael.
