Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:58715 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYIBNUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 09:20:55 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1173461eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 06:20:53 -0700 (PDT)
Date: Tue, 2 Sep 2008 16:20:48 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net,
	Jan-Espen Pettersen <sigsegv@radiotube.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080902132045.GD19172@google.com> (sfid-20080902_152059_287923_F564955E)
References: <20080901160658.GA11063@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080901160658.GA11063@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 01, 2008 at 07:06:58PM +0300, Michael S. Tsirkin wrote:
> Starting with 2.6.27-rc5, my T60p sometimes fails to associate
> with an access point after suspend to ram/resume.
> 
> This does not seem to ever happen on 2.6.27-rc4.
> 
> When this happens, I observe the following messages in dmesg:
> (AP mac masked out with XX):
> 
> ...
>  
> Reverting 8ab65b03b7893da4a49009e7e356e36e27b0c407 seems to make
> the card associate properly after suspend, for me.

FYI I created a bugzilla entry to track this:
http://bugzilla.kernel.org/show_bug.cgi?id=11476

-- 
MST



