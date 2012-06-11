Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2FKPFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:05:11 -0400
Date: Mon, 11 Jun 2012 11:05:04 -0400
From: Dave Jones <davej@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
	David Miller <davem@davemloft.net>,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
Message-ID: <20120611150504.GA13265@redhat.com> (sfid-20120611_170551_643204_B083DC47)
References: <1339423241.4999.53.camel@lappy>
 <20120611144134.GX22557@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120611144134.GX22557@sortiz-mobl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2012 at 04:41:34PM +0200, Samuel Ortiz wrote:
 > Hi Sasha,
 > 
 > On Mon, Jun 11, 2012 at 04:00:41PM +0200, Sasha Levin wrote:
 > > Hi all,
 > > 
 > > I've stumbled on the following while fuzzing with trinity inside a KVM tools guest, running on 3.5-rc2:
 > > 
 > Thanks for the report, it could be worth adding this one to
 > bugzilla.kernel.org.
 > 
 > What's trinity ?

http://codemonkey.org.uk/projects/trinity/

	Dave

