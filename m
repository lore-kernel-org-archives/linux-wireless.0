Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:40378 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbZKRSbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 13:31:35 -0500
Received: by ey-out-2122.google.com with SMTP id 25so262353eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 10:31:40 -0800 (PST)
Subject: Re: [PATCH] mac80211: use a structure to hold the mesh config information element
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Rui Paulo <rpaulo@gmail.com>
In-Reply-To: <1258568789.30511.52.camel@johannes.local>
Date: Wed, 18 Nov 2009 18:31:37 +0000
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Message-Id: <FCD5549E-8474-4006-B945-7DDC6BFBC1F9@gmail.com>
References: <1258568579-21900-1-git-send-email-rpaulo@gmail.com> <1258568789.30511.52.camel@johannes.local>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 Nov 2009, at 18:26, Johannes Berg wrote:

> Cool, thanks.
> 
>>                case WLAN_EID_MESH_CONFIG:
>>                        elems->mesh_config = pos;
>> -                       elems->mesh_config_len = elen;
>>                        break;
> 
> Should there be a length check here?

Yes, I forgot about that :-(

I'll submit a new one.
--
Rui Paulo

