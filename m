Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:39136 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJFUYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 16:24:08 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1131135nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 13:24:07 -0700 (PDT)
Message-ID: <f6ca9fed0810061324v1cbfc538k98f5b49426b61f08@mail.gmail.com> (sfid-20081006_222414_293087_5414D939)
Date: Mon, 6 Oct 2008 22:24:07 +0200
From: drago01 <drago01@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223320354.11272.224.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <1223320354.11272.224.camel@violet.holtmann.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 6, 2008 at 9:12 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Tomas,
>
>> > This makes the code surrounding the last few things using
>> > IWL_SET_BITS16 actually readable and removes the macros
>> > so nobody will ever consider using them again.
>> >
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>>
>> I don't want these macros eithers but I NACK any patches with cursing
>> in the commit logs.
>
> did I miss an internal joke here? I fail to see the cursing ;)

he is talking about the "crap" in the subject ;)
