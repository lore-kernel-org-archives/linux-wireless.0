Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1551 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaA0IlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 03:41:13 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v2 3/6] cfg80211: Enable GO operation on additional
 channels
Date: Mon, 27 Jan 2014 08:41:09 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03336BEC2@HASMSX106.ger.corp.intel.com> (sfid-20140127_094146_038378_3EF100D1)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <1389801162-14488-4-git-send-email-ilan.peer@intel.com>
 <20140125000901.GA28512@garbanzo.do-not-panic.com>
In-Reply-To: <20140125000901.GA28512@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Adding the link to the latest definitions of FCC's 5GHz unlicensed spectrum.

Regards,

Ilan.

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> Rodriguez
> Sent: Saturday, January 25, 2014 02:09
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org; wireless-regdb@lists.infradead.org
> Subject: Re: [PATCH v2 3/6] cfg80211: Enable GO operation on additional
> channels
> 
...

> > + * @freq: the frequency for which we want to get the UNII band.
> > +
> > + * U-NII bands are defined by the FCC in C.F.R 47 part 15.
> > + *
> > + * Returns -EINVAL if freq is invalid, 1 for UNII-1, 2 for UNII-2,
> > + * 3 for UNII-2e, 4 for UNII-3.
> 
> What's your source for UNII definition? Can you provide a URL?
> 

http://www.fcc.gov/document/5-ghz-unlicensed-spectrum-unii

http://hraunfoss.fcc.gov/edocs_public/attachmatch/FCC-13-22A1.pdf

