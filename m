Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:53937 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762977AbZDCLrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 07:47:03 -0400
Received: by gxk4 with SMTP id 4so2217987gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 04:47:00 -0700 (PDT)
Message-ID: <49D5F730.5020205@gmail.com> (sfid-20090403_134712_687491_D04BF019)
Date: Fri, 03 Apr 2009 07:46:56 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [Fwd: Re: Trouble Associating with ath5k on AR5212]
Content-Type: multipart/mixed;
 boundary="------------000409000502090407050304"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000409000502090407050304
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Forwarding back to the list, as I was silly and sent as HTML originally...

-------- Original Message --------
Bob Copeland wrote:
> On Thu, Apr 2, 2009 at 10:12 AM, Will Keaney <keaneyw@gmail.com> wrote:
>   
>> Hello,
>> I have been following the wireless-testing branch for a few months,
>> hoping with each revision that my Atheros card would finally work
>> properly with ath5k. �So far, I've been able to scan for and see nearby
>> networks, but I haven't been able to associate to them.
>>     
>
> Does limiting wpa_supplicant to only scan the 2 GHz channels help?
>
> e.g. setting "scan_freq=2412 2437 2462" in your wpa_supplicant.conf
> scans 1 6 and 11.
>   
Thanks for the suggestion.  It appears that my installed version of 
wpa_supplicant does not support the scan_freq parameter.  A google 
search found precisely one example of it being used, in a sample 
wpa_supplicant.conf in the epitest git repo.
For what it's worth, I have also tried using iwconfig to associate to 
the neighbor's network under ath5k without success.  So I don't think 
it's related to wpa_supplicant's scanning algorithm.

Will Keaney

--------------000409000502090407050304
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYyLjAuMTEg
KEdOVS9MaW51eCkNCkNvbW1lbnQ6IFVzaW5nIEdudVBHIHdpdGggTW96aWxsYSAtIGh0dHA6
Ly9lbmlnbWFpbC5tb3pkZXYub3JnDQoNCmlFWUVBUkVDQUFZRkFrblZaRW9BQ2drUWpmYXlX
Q0E4ZERIMHlRQ2RHeVd5dFQ0V2E0VXBBalVqNjJRYkY2RU8NCnlYNEFuUkZxOHBGS1Ezc3Jl
VXZYcVVMZCtOK201VG1TDQo9bGFkdg0KLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0tDQoN
Cg==
--------------000409000502090407050304--
