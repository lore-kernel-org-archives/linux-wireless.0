Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51407.mail.re2.yahoo.com ([206.190.38.186]:39698 "HELO
	web51407.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932104Ab0ARQUc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 11:20:32 -0500
Message-ID: <860907.56395.qm@web51407.mail.re2.yahoo.com>
Date: Mon, 18 Jan 2010 08:20:31 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: "iwconfig wlan0 rate auto" fails on latest wireless-testing with ath9k
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can somebody confirm this problem?

 -- 
Regards 
Joerg 




----- Ursprüngliche Mail ----
> Von: Joerg Pommnitz <pommnitz@yahoo.com>
> An: linux-wireless@vger.kernel.org
> Gesendet: Donnerstag, den 14. Januar 2010, 13:39:17 Uhr
> Betreff: "iwconfig wlan0 rate auto" fails on latest wireless-testing with ath9k
> 
> Hello all,
> if I set a fixed data rate with iwconfig I can't get out anymore.
> Trying to switch back to automatic rate control gives an error message:
> 
> Script started on Thu Jan 14 13:18:14 2010
> root@ath9k-0-007:~# iwconfigwlan0
> Warning: Driver for device wlan0 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> wlan0     IEEE 802.11abgn  ESSID:"athtest5200"  
>           Mode:Ad-Hoc  Frequency:5.2 GHz  Cell: 02:02:6F:23:12:0B  
>           Tx-Power=20 dBm  
>           Retry limit:7   RTSthr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           
> root@ath9k-0-007:~# iwconfigwlan0 rate 6M
> root@ath9k-0-007:~# iwconfigwlan0
> Warning: Driver for device wlan0 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> wlan0     IEEE 802.11abgn  ESSID:"athtest5200"  
>           Mode:Ad-Hoc  Frequency:5.2 GHz  Cell: 02:02:6F:23:12:0B  
>           Tx-Power=20 dBm  
>           Retry limit:7   RTSthr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           
> root@ath9k-0-007:~# iwconfigwlan0 rate auto
> Error for wireless request "Set Bit Rate" (8B20) :
>     SET failed on device wlan0 ; Invalid argument.
> root@ath9k-0-007:~# 
> Script done on Thu Jan 14 13:18:56 2010
> 
> Funny thing is, not even "rmmodath9k mac80211" is enough to get out of
> the fixed data rate.
> 
> Any ideas? And, BTW. will there be a way to set the data rate with iw?
> 
> -- 
> Regards 
> Joerg 
> 
> __________________________________________________
> Do You Yahoo!?
> Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen 
> Massenmails. 
> http://mail.yahoo.com


__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
