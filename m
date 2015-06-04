Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.203]:47011 "EHLO
	johanna3.rokki.sonera.fi" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752245AbbFDTcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 15:32:46 -0400
Date: Thu, 4 Jun 2015 22:32:34 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: [BUG 4.1.0-rc6] iwlwifi: "Error sending REPLY_TXFIFO_FLUSH: time
 out after 2000ms"
Message-ID: <20150604193234.GA1795@node.dhcp.inet.fi> (sfid-20150604_213250_277306_1354A704)
References: <20150604173710.GA1188@node.dhcp.inet.fi>
 <1433441600.17813.0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433441600.17813.0.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 04, 2015 at 06:13:22PM +0000, Grumbach, Emmanuel wrote:
> On Thu, 2015-06-04 at 20:37 +0300, Kirill A. Shutemov wrote:
> > Hi,
> > 
> > I've trigered the bug few times after several suspend/resume cycles.
> > Hardware is Thinkpad X1 2013 with Intel Corporation Centrino Advanced-N
> > 6205 (8086:0085) (rev 96).
> > 
> 
> This really looks like the platform problem people have been hitting.
> The device is no longer accessible.
> Unfortunately, I really don't know what we can do in that case.

Is there anything I can do to provide info you need?

-- 
 Kirill A. Shutemov
