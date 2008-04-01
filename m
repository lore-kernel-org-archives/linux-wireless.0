Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58390 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbYDAV0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 17:26:44 -0400
Subject: Re: Problems with RTL8187 USB device
From: Pavel Roskin <proski@gnu.org>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us>
References: <47C49D21.1030905@lwfinger.net>
	 <20080227010732.GB3066@tuxdriver.com>
	 <pan.2008.03.25.20.31.22.955127@gimpelevich.san-francisco.ca.us>
	 <pan.2008.04.01.15.41.45.711513@gimpelevich.san-francisco.ca.us>
	 <20080401175156.GB14670@tuxdriver.com>
	 <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 17:26:42 -0400
Message-Id: <1207085202.27851.4.camel@dv> (sfid-20080401_222650_260100_D1CBBDD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-01 at 11:07 -0700, Daniel Gimpelevich wrote:

> Any hope of posting the incomplete patch you have so far, for a possible
> group effort?

I have a RTL8187b device (0bda:8189 Realtek Semiconductor Corp. RTL8187B
Wireless 802.11g 54Mbps Network Adapter).  I'm ready to test any patches
on kernels with most debugging options enabled.  And I know how to
sparse :-)

There is a patched driver for Intel's ieee80211 here:
http://www.datanorth.net/~cuervo/rtl8187b/

All that's needed is to port the changes to mac80211.  It shouldn't be
hard.

-- 
Regards,
Pavel Roskin
