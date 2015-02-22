Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([109.74.194.28]:32930 "EHLO mrs.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbbBVWbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 17:31:07 -0500
Message-ID: <54EA56D7.2050409@mrs.ro> (sfid-20150222_233123_489812_E6523D12)
Date: Mon, 23 Feb 2015 00:23:19 +0200
From: Valentin Manea <linux-wireless@mrs.ro>
MIME-Version: 1.0
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Harary, Eran" <eran.harary@intel.com>
Subject: Re: iwlwifi: ampdu_factor for iwl-6000 is set to 0
References: <54E9C852.50809@mrs.ro> <1424607564.20465.1.camel@egrumbacBox> <1424636206.30822.1.camel@egrumbacBox>
In-Reply-To: <1424636206.30822.1.camel@egrumbacBox>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
On 2015-02-22 22:16, Grumbach, Emmanuel wrote:
> Hi again (fixed your address, I hope it will not bounce this time...)
Sorry, stupid fingers caused the bad spelling, anyway now both aliases 
are valid.
> Please test the patch attached.
I can confirm this patch fixes the problem on my hardware, my throughput 
is back to 164 Mbit/s

Thank you very much,
Valentin
