Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43228 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbYGNWCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:23 -0400
Date: Tue, 15 Jul 2008 01:01:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
Message-ID: <20080714220138.GD5155@jm.kir.nu> (sfid-20080715_000234_566865_87F3E3E1)
References: <20080617154008.883383150@localhost> <1215625246.3246.40.camel@johannes.berg> <1215626936.3246.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1215626936.3246.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 09, 2008 at 08:08:56PM +0200, Johannes Berg wrote:

> Just realised that it doesn't handle VLANs properly. Could you add a
> static MAC/VLAN mapping to hostapd to make VLANs possible without
> setting up radius? :)

Well, I could, but this doesn't sound like a real world feature.. I
would assume it would be relatively simple addition to the file-based
MAC ACL (accept_mac_file) to allow optional listing of VLAN ID that
would then be used as if it came from the authentication server.

Anyway, It shouldn't require much complexity to set up FreeRADIUS with
two users that are assigned to different VLAN groups. hostapd.conf lists
the needed tunnel attributes for this.. ;-)

-- 
Jouni Malinen                                            PGP id EFC895FA
