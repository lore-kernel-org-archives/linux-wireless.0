Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:3623 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYJUVdd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 17:33:33 -0400
Received: by yw-out-2324.google.com with SMTP id 9so475995ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 14:33:32 -0700 (PDT)
Message-ID: <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com> (sfid-20081021_233338_052611_834C0617)
Date: Tue, 21 Oct 2008 23:33:32 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "reinette chatre" <reinette.chatre@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1224624324.28639.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 11:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-21 at 11:27 -0700, reinette chatre wrote:
>> Two new versions of 3945 uCode is now available for download from
>> http://intellinuxwireless.org/?n=Downloads. Two versions are available
>> as we have updated the API version of the uCode and included pending
>> fixes in both API versions.
>>
>> Version 15.28.1.8 supports API v1 and can be used with most current 3945
>> drivers. Version 15.28.2.8 (API v2) is required when you start using the
>> latest 3945 driver from wireless-testing at the time it includes the
>> patch "iwl3945 : Fix a-band association for passive channels".
>
> Can you make the driver work with the old ucode? We even do that for
> drivers where we don't control the ucode like b43...

What for?
Tomas
