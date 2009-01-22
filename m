Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:40301 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZAVPrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:47:12 -0500
Received: from smtp2.int-evry.fr (smtp2.int-evry.fr [157.159.10.45])
	by smtp4.int-evry.fr (Postfix) with ESMTP id 227CFFE409C
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 16:19:50 +0100 (CET)
Received: from smtp-ext.int-evry.fr (smtp-ext.int-evry.fr [157.159.11.17])
	by smtp2.int-evry.fr (Postfix) with ESMTP id 89954405043
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 16:19:44 +0100 (CET)
Received: from [127.0.0.1] (unknown [157.159.100.239])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-ext.int-evry.fr (Postfix) with ESMTP id 7E08490004
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 16:19:42 +0100 (CET)
Message-ID: <49788E88.5000608@telecom-sudparis.eu> (sfid-20090122_164716_230276_D922DB9D)
Date: Thu, 22 Jan 2009 16:19:36 +0100
From: Chanthearith HUON <chanthearith.huon@telecom-sudparis.eu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: SIOCSIFFLAGS: Name not unique on network
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I would like to build a small mesh network based on 802.11s using 
open80211s for performance testing.
After reading linuxwireless.org <http://linuxwireless.org>, I came up 
with "iw" command to create new virtual interface and MP.

Here is my wireless card
"Intel PRO/Wireless 3845ABG"

Its installed driver
"iwl3945"

This wireless card is not listed 
in http://linuxwireless.org/en/users/Devices 
<http://linuxwireless.org/en/users/Devices>
but the driver is in the 
list http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211drivers 
<http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211drivers>

The OS is ubuntu Intrepid Ibex 8.10 with kernel 2.6.27-9-generic

After creating new interface for mesh "iw dev wlan0 interface add mesh 
type mp mesh_id 100". I turned the mesh interface up by "ifconfig mesh up".
I got following error message
" SIOCSIFFLAGS: Name not unique on network "

I got the same error message for " ifconfig mesh 192.168.1.1 "

I search on the net but not much help.

Thank very much,
Thierry
