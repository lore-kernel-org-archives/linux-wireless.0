Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587Ab3CHRVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 12:21:47 -0500
Date: Fri, 8 Mar 2013 18:21:45 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: Re: [linux-nfc] [GIT] [3.10] NFC pull request
Message-ID: <20130308172145.GA30581@sortiz-mobl> (sfid-20130308_182151_119213_D7FD9186)
References: <20130308114406.GB27873@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130308114406.GB27873@sortiz-mobl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Fri, Mar 08, 2013 at 12:44:06PM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> This is the first NFC pull request for 3.10.
After pulling this one on top of your current tree, I just realized that it
fails to build due to the hlist changes (dropping the node parameters from
iterarors).
I'll rebase my changes on top of your HEAD and re-send a pull request, sorry.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
