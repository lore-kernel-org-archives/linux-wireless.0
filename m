Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:15884 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYKIHN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 02:13:57 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2004344wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2008 23:13:56 -0800 (PST)
Message-ID: <1ba2fa240811082313q57cca1fayf94aea9357f52a58@mail.gmail.com> (sfid-20081109_081405_907396_2AE5B960)
Date: Sun, 9 Nov 2008 09:13:56 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [PATCH 0/2] iwlwifi fixes for stable 2.6.27
Cc: stable@kernel.org, rjw@sisk.pl, linville@tuxdriver.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081109041808.GA1017@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226191867-22324-1-git-send-email-tomas.winkler@intel.com>
	 <20081109041808.GA1017@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 9, 2008 at 6:18 AM, Greg KH <greg@kroah.com> wrote:
> On Sun, Nov 09, 2008 at 02:51:05AM +0200, Tomas Winkler wrote:
>> First one didn't make it into the stable due to type in emails
>> Second is important bug fix that was kept out 2.6.27 merging window.
>> There is no visible kernel bug but w/o this patch the 5000 iwlwifi HW
>> is left un-calibrated which is critical
>
> Are these already in Linus's tree?  If so, do you have a git commit id
> for them?

iwlwifi: fix suspend to RAM in iwlwifi 10d0bd56966571d0324dfd9bbb8aa913a60bef5f
iwlwifi: generic init calibrations framework
6e21f2c109edd746a10e08186484bae8168cdd0c

Thanks
Tomas
