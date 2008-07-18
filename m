Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:10428 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYGRTfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 15:35:53 -0400
Received: by nf-out-0910.google.com with SMTP id d3so167547nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 12:35:52 -0700 (PDT)
Message-ID: <f6ca9fed0807181235i33125343qab4804b675bafdf9@mail.gmail.com> (sfid-20080718_213606_468799_996E63C9)
Date: Fri, 18 Jul 2008 21:35:52 +0200
From: drago01 <drago01@gmail.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 random firmware crashes
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f6ca9fed0807170428i4b386e46sb030316343f4bd4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0807140437i2563cfa1ge68a06ef1040d0f8@mail.gmail.com>
	 <4220499A1B034C4FA93B547BA01E1FF0017469B4@orsmsx413.amr.corp.intel.com>
	 <f6ca9fed0807170423x7f7bd534x5ab63f985564f92@mail.gmail.com>
	 <f6ca9fed0807170428i4b386e46sb030316343f4bd4a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 1:28 PM, drago01 <drago01@gmail.com> wrote:
> On Thu, Jul 17, 2008 at 1:23 PM, drago01 <drago01@gmail.com> wrote:
>> On Mon, Jul 14, 2008 at 8:05 PM, Cahill, Ben M <ben.m.cahill@intel.com> wrote:
>>> Try loading driver using module param:
>>>
>>> debug=0x43fff
>>>
>>> This will provide more information in the log, including an event log
>>> (where you see "Microcode SW Error detected" in your log, you would have
>>> captured Event Log if you had the debug=0x43fff setting).
>>
>> It happend again and this time I captured the log.
>> Debug output including event log is attached.
>>
>
> Resend with compressed attachment.
>

Happend again ... is there a tool that "decrypts" the event log to be readable?
The whole thing does not make any sense to me and the log does not
tell me what is really happening to debug it.
