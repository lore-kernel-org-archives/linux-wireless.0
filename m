Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35675 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBLJoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 04:44:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21243.16970.514799.362874@gargle.gargle.HOWL> (sfid-20140212_104422_682844_CD88AB83)
Date: Wed, 12 Feb 2014 15:13:38 +0530
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Intel Linux Wireless \(ilw\@linux.intel.com\)" <ilw@linux.intel.com>
Subject: RE: [PATCH] iwlwifi: disable TX AMPDU by default for iwldvm
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D663F1@HASMSX103.ger.corp.intel.com>
References: <52FB360D.2060502@gmail.com>
	<1392195269-5514-1-git-send-email-egrumbach@gmail.com>
	<20140212091008.GB1315@redhat.com>
	<20140212092150.GC1315@redhat.com>
	<0BA3FCBA62E2DC44AF3030971E174FB303D663F1@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grumbach, Emmanuel wrote:
> I have seen reports from many users and many devices - and unfortunately I
> have never been able to reproduce - so I can't know if it affects all the
> devices. All I can see is that I saw reports on very old devices (5150) and
> with more recent devices (2230).

Is 5100 a very old device ? I have one of those cards in a laptop and starting
11n TX traffic usually results in a crash like this: http://pastebin.com/HtUdCLR3

Sujith


