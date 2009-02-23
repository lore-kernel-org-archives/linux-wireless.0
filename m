Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:10196 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZBWXyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 18:54:07 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2756127wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 15:54:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910902231331ue4acad1q63fa995f7480ae71@mail.gmail.com>
References: <49A313EC.4070005@gmail.com>
	 <69e28c910902231331ue4acad1q63fa995f7480ae71@mail.gmail.com>
Date: Mon, 23 Feb 2009 15:54:05 -0800
Message-ID: <43e72e890902231554g4d70e1a8qe6ad4574e25bae49@mail.gmail.com> (sfid-20090224_005412_247913_7C0AD11D)
Subject: Re: new pci_ids device for ath[59]k ?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 1:31 PM, G=C3=A1bor Stefanik <netrolller.3d@gma=
il.com> wrote:
> On Mon, Feb 23, 2009 at 10:23 PM, Xose Vazquez Perez
> <xose.vazquez@gmail.com> wrote:
>> hi,
>>
>> I have found in windows inf file a new device not supported by
>> ath[59]k drivers: 0x168C,0x1014
>>
>> the labels only are:
>> 11b/g   Wireless LAN Mini PCI Express Adapter
>> 11a/b/g Wireless LAN Mini PCI Express Adapter
>> 11a/b/g Wireless LAN Mini PCI Adapter II
>>
>>
>> is this device out there ? or was it only a manufacturer's HW test ?
>
>
> CCing Luis, he probably knows more about this.

ath5k claims it already:

        { PCI_VDEVICE(ATHEROS, 0x1014), .driver_data =3D AR5K_AR5212 },
/* IBM minipci 5212 */

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
