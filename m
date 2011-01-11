Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34032 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1AKNFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 08:05:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PcduL-0005K7-Ug
	for linux-wireless@vger.kernel.org; Tue, 11 Jan 2011 14:05:05 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 14:05:05 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 14:05:05 +0100
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: Re: [PATCH v2 2/4] iw: Add channel busy time to survey
Date: Tue, 11 Jan 2011 13:00:06 +0000 (UTC)
Message-ID: <loom.20110111T135916-985@post.gmane.org>
References: <20110111005107.10231.81618.stgit@localhost6.localdomain6>  <20110111005112.10231.46375.stgit@localhost6.localdomain6> <1294734744.3611.3.camel@jlt3.sipsolutions.net> <loom.20110111T135315-64@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

jpo234 <pommnitz@...> writes:
> The C99 way would be to use the PRIu64 macro (see stdint.h).

Sorry, make this <inttypes.h>.


