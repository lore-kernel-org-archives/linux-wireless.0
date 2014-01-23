Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaAWJXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:23:02 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Petko Manolov <petkan@nucleusys.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: iwlwifi crash with 3.13
Date: Thu, 23 Jan 2014 09:22:46 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com> (sfid-20140123_102307_941935_455597CD)
References: <20140123091659.GE9077@localhost>
In-Reply-To: <20140123091659.GE9077@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> 	Hi guys,
> 
> Connecting to 5GHz router with my iwlwifi (on Yoga 2 Pro, 3.13 kernel) seems
> to work fine, but 'dmesg' doesn't look pretty.  This is what
> 'lspci' say about the actual controller: Intel Corporation Wireless 7260 (rev
> 6b).
> 
> IIRC this was going on with 3.11.y and 3.12.y as well.  Please let me know if i
> can help with anything else.
> 

Can you share the very first iwlwifi lines of your dmesg?
I'd like to check the fw version.
Also - can you please update to latest firmware from http://wireless.kernel.org/en/users/Drivers/iwlwifi.
You can take iwlwifi-7260-ucode-22.1.7.0.tgz or iwlwifi-7260-ucode-22.15.8.0.tgz.
 
