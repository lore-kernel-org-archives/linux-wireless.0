Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48945 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2AaJk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:40:58 -0500
Received: by iacb35 with SMTP id b35so617183iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:40:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327953181.3626.107.camel@cumari>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
	<1327924857-1250-2-git-send-email-eliad@wizery.com>
	<1327953181.3626.107.camel@cumari>
Date: Tue, 31 Jan 2012 11:40:57 +0200
Message-ID: <CAB3XZEd=76pbZ8pX8+7Xn6NzfKpVN5nYTf+JrJgeNJz1nizfFA@mail.gmail.com> (sfid-20120131_104103_304667_6DCB7B2E)
Subject: Re: [PATCH 01/12] wl12xx: fw api change - add role_id to set_template
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 9:53 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2012-01-30 at 14:00 +0200, Eliad Peller wrote:
>> @@ -191,7 +193,7 @@ enum cmd_templ {
>>  /* unit ms */
>>  #define WL1271_COMMAND_TIMEOUT     2000
>>  #define WL1271_CMD_TEMPL_DFLT_SIZE 252
>> -#define WL1271_CMD_TEMPL_MAX_SIZE  548
>> +#define WL1271_CMD_TEMPL_MAX_SIZE  512
>> #define WL1271_EVENT_TIMEOUT       750
>
> Is this change here on purpose? Is it really related to the FW API
> change?
>
yes. this const determines the size of the wl1271_cmd_template_set struct.

Eliad.
