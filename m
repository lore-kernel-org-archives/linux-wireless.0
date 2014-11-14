Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37119 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbaKNRD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 12:03:57 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so1080494obc.25
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2014 09:03:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54648C50.6000702@broadcom.com>
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
	<545F4611.3010207@broadcom.com>
	<CAMP44s2V59VDx0s7q5Yr=KvGZNn8ptRJGHS4W8Ja=+ciKZaSzg@mail.gmail.com>
	<54633939.6000400@broadcom.com>
	<CAMP44s1DOA31ob24=qzz83MnVFmm60EpgaPYvLbwUv-AP5FRbw@mail.gmail.com>
	<54648C50.6000702@broadcom.com>
Date: Fri, 14 Nov 2014 11:03:56 -0600
Message-ID: <CAMP44s0j+i3zADu=Y3fUWqNEgDFeESs2_aFYmxQt9kZRcXkCjA@mail.gmail.com> (sfid-20141114_180400_615568_1E62076D)
Subject: Re: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2014 at 4:47 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 12-11-14 16:23, Felipe Contreras wrote:
>> On Wed, Nov 12, 2014 at 4:40 AM, Arend van Spriel <arend@broadcom.com> wrote:

>> I tried this patch, and although it seems to make a difference, it
>> still doesn't work.
>>
>> http://people.freedesktop.org/~felipec/dmesg-brcm-2.txt
>
> Hi Felipe,
>
> All the messages to the firmware seem ok. If connection would succeed I
> normally see a LINK event followed by SET_SSID event. In your log I only
> see the SET_SSID event with failed status, hence the connect is
> unsuccessful. Do you have any control over the AP? Could you try without
> WPA security to quickly confirm connection works? May help in root
> causing the issue.

I tried disabled WPA security, it's still not working.

-- 
Felipe Contreras
