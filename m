Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34582 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbcGTNXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 09:23:17 -0400
Received: by mail-io0-f179.google.com with SMTP id q83so47317324iod.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 06:23:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <efa3441022124e74af56753a70041eee@SC-EXCH04.marvell.com>
References: <CAEOnXSfd6K36cOcUfqy8rBT27TbH9PGy7U4z3TU0N2YWc7GXqA@mail.gmail.com>
 <efa3441022124e74af56753a70041eee@SC-EXCH04.marvell.com>
From: Luana Borgia <luanaborgia1969@gmail.com>
Date: Wed, 20 Jul 2016 15:23:15 +0200
Message-ID: <CAD3r-iQScbuUiGiF3uDKzMk-0mycG3WVFDGaYCy6aPxAEjq3mg@mail.gmail.com> (sfid-20160720_152320_490096_D8F932F2)
Subject: Re: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nestor Machno <nestor.machno89@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,
any news about this issue? I've the same problem also..

Security a part, we can't leave the WIFI open or just with WEP because
we get too many not trusted connection that consume a lot of our
bandwidth

Thanks, regards
Luana

2016-07-08 11:15 GMT+02:00 Amitkumar Karwar <akarwar@marvell.com>:
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Nestor Machno
>> Sent: Thursday, July 07, 2016 6:07 AM
>> To: linux-wireless@vger.kernel.org
>> Subject: Fwd: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
>>
>> Hi All,
>> Amitkumar, can you confirm if this this is a bug or today is fixed?
>
> Yes. This is a bug in our firmware. ADHOC in WPA/WPA2 security is broken. We have asked firmware experts to look into this. As we have a mid-year shutdown this week, they will be able to check the problem next week only. However ADHOC in open mode should work as expected
>
>>
>> Vincent, I had also faced similar issue on Surface Pro 2 with backports
>> from 4.1... So here few question:
>>
>> * I saw in 1st post that you where working to make work the
>> wpa_supplicant with mixed configuration for adhoc (wpa-none + wpa-ibss),
>> but also in recent post that you focus mostly on debugging wpa-ibss. I
>> suggest to focus your test on one wpa mode and I think wpa-none better
>> because it's easier..
>> * Why you are not testing the latest backport from upstream kernel? as
>> you can know Marvell is focus most to fix open issue on current stable
>> release, I saw from commit that recently they fix something about WPA on
>> mixflex, see
>> https://backports.wiki.kernel.org/index.php/Documentation/compat-
>> drivers/hacking
>> * Would be good information to know if you tested also on backport 3.x,
>> did you?  I know mwifiex's WPA stack changed a lot from 3.x kernel.
>> * To support you more, could you enable debug info and provide full log
>> of your setup? .config? patch? anything else?
>> * Can you share us your hacked backport?
>> * Lat question Vincent, are you working for AIRBUS, ACTIA or THALES ?
>> :)
>>
>> Best Regards
>> Nestor
>>
>> On Mon, Jun 13, 2016 at 7:42 AM, Vincent CESSON
>> <vincent.cesson@smile.fr> wrote:
>> > Hi Amitkumar,
>> >
>> > Here are the wpa_supplicant logs (with CONFIG_IBSS_RSN=y enabled) from
>> > the two devices. Beside wpa_supplicant, I manually set IPs
>> > 192.168.1.xy with command "ifconfig mlan0 192.168.1.xy" and then I try
>> > to ping each other, without success.
>> >
>
> Regards,
> Amitkumar
