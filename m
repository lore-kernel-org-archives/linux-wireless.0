Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaAZWNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 17:13:39 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v2 0/6] Enable additional channels for use
Date: Sun, 26 Jan 2014 22:13:35 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03336BCD2@HASMSX106.ger.corp.intel.com> (sfid-20140126_231342_223431_3C1FDB14)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <20140125002416.GD28512@garbanzo.do-not-panic.com>
In-Reply-To: <20140125002416.GD28512@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> Looks good but needs a bit of work. In particular the biggest concern I have is
> the last_request thing, and the feature flag on the wiphy. Other than that,
> tons of cleanup and one last
> requirement: please document this on the wireless wiki on the regulatory
> page, once accepted.
> 
> http://wireless.kernel.org/en/developers/Regulatory/processing_rules
> 

Sure :)
