Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58789 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaAIAV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 19:21:58 -0500
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id s090LvuJ029136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 8 Jan 2014 16:21:58 -0800
Message-ID: <52CDEBA5.1030903@candelatech.com> (sfid-20140109_012202_387098_2FBA1CD2)
Date: Wed, 08 Jan 2014 16:21:57 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Typo in software crypt?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should the below comment say instead:

"That's ok though, we don't need _it_ to decrypt the frame" ?

		/*
		 * The device doesn't give us the IV so we won't be
		 * able to look up the key. That's ok though, we
		 * don't need to decrypt the frame, we just won't
		 * be able to keep statistics accurate.
		 * Except for key threshold notifications, should
		 * we somehow allow the driver to tell us which key
		 * the hardware used if this flag is set?
		 */


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

