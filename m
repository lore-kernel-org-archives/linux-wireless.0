Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipmx5.colorado.edu ([128.138.128.235]:40283 "EHLO
	ipmx5.colorado.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3CNHQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 03:16:01 -0400
Message-ID: <514176ED.6010302@colorado.edu> (sfid-20130314_081607_938352_D5F9A6EF)
Date: Thu, 14 Mar 2013 01:06:21 -0600
From: Matthew Monaco <Matthew.Monaco@Colorado.EDU>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: p2p / wifi-direct PIN and DHCP setup.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

The documentation on p2p is a little sparse right now.

My first question is about PIN number. I have no problem running p2p_find;
p2p_connect from my workstation to initiate a connection to an Android Linux
phone. However, is there a way to set up wpa_supplicant.conf to allow for phones
to connect to the workstation without or with a specified pin?

Second question: is there a way to specify the action script in
wpa_supplicant.conf so that I can set the IP of the newly created p2p device?


Thanks!
Matt
