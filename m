Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:33689 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXBUBsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 20:48:03 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJgZ0-000191-6n
	for linux-wireless@vger.kernel.org; Tue, 20 Feb 2007 20:46:34 -0500
Subject: Re: [PATCH] rt2x00: Fix max_rssi values signedness bug
From: Pavel Roskin <proski@gnu.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702202025.33485.flamingice@sourmilk.net>
References: <200702202102.14354.mb@bu3sch.de> <1172020729.6042.2.camel@dv>
	 <200702202025.33485.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 20:47:57 -0500
Message-Id: <1172022477.6042.4.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-20 at 20:25 -0500, Michael Wu wrote:
> On Tuesday 20 February 2007 20:18, Pavel Roskin wrote:
> > So, there will be no dBm on PowerPC.  I think those fields should be
> > "signed char".
> Like in the patch Michael Buesch posted right before this one?

Yes.  Sorry for the noise.

-- 
Regards,
Pavel Roskin

