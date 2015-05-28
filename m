Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbbE1Pwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:52:49 -0400
Message-ID: <1432828355.3499.41.camel@infradead.org> (sfid-20150528_175309_246419_675C6560)
Subject: Re: [PATCH 00/20] MODSIGN: Use PKCS#7 for module signatures [ver #5]
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: mcgrof@gmail.com, mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com
Date: Thu, 28 May 2015 16:52:35 +0100
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-28 at 16:46 +0100, David Howells wrote:
> 
> Additionally, the last four patches are provisionally added to support firmware
> signing, but will need further modification (ie. registration of OIDs) before
> they can be committed, but are included for comment:

I'd quite like to see a way for a given driver to specify the key with
which its firmware needs to be signed. Perhaps an extra argument to the
request_firmware() call giving the X509v3 Subject Key Identifier of the
cert to be trusted?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

